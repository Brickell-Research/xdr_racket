#lang typed/racket

(require (for-syntax syntax/parse
                     racket/syntax)) ; format-id lives here

(provide define-xdr-struct)

;; XDR Struct
;  Structures are declared as follows:
;
;        struct {
;           component-declaration-A;
;           component-declaration-B;
;           ...
;        } identifier;
;
;  The components of the structure are encoded in the order of their
;  declaration in the structure.  Each component's size is a multiple of
;  four bytes, though the components may be different sizes.
;
;        +-------------+-------------+...
;        | component A | component B |...                      STRUCTURE
;        +-------------+-------------+...

;; An example struct:
; struct SCPQuorumSet
; {
;     uint32 threshold;
;     NodeID validators<>;
;     SCPQuorumSet innerSets<>;
; };
;; ---------------- compile-time helpers ----------------
(begin-for-syntax
  (define-syntax-class SimpleType
    #:description "Type := id"
    (pattern id))

  ;; Default value for a given type syntax
  (define (default-expr ty-stx)
    (syntax-parse ty-stx
      ;; match literal identifiers with ~datum
      [(~or (~datum Integer) (~datum Natural) (~datum Real) (~datum Number)) #'0]
      [(~datum String)  #'""]
      [(~datum Boolean) #'#f]
      [(~datum Bytes)   #'#""]
      [_ (raise-syntax-error
          #f
          (format "no default known for type: ~a" (syntax-e ty-stx))
          ty-stx)]))

  ;; Field syntax: user writes [field Type]; we synthesize a zero attr
  (define-syntax-class Field
    (pattern [field:id type:SimpleType]
      #:attr zero (default-expr #'type))))

;; ---------------- macro ----------------
(define-syntax (define-xdr-struct stx)
  (syntax-parse stx
    [(_ name:id (f:Field ...))
     #:with empty-id (format-id #'name "~a-empty" #'name)
     #:with from-bytes-id (format-id #'name "~a-from-bytes" #'name)
     #'(begin
         ;; Struct definition
         (struct name ([f.field : f.type] ...))

         ;; Construct a struct with default values
         (: empty-id (-> name))
         (define (empty-id)
           (name f.zero ...)))]))
;; ------------------------------------------------------------------