#lang typed/racket

(require (for-syntax syntax/parse
                     racket/syntax) ; format-id lives here
         "integer.rkt"
         "boolean.rkt"
         "string.rkt"
         "opaque.rkt"
         "floating-point.rkt"
         "hyper.rkt")

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
      [(~datum Float)   #'0.0]
      [_ (raise-syntax-error
          #f
          (format "no default known for type: ~a" (syntax-e ty-stx))
          ty-stx)]))

  ;; Generate encoding expression for a field based on its type
  (define (encode-expr field-access ty-stx)
    (syntax-parse ty-stx
      [(~or (~datum Integer) (~datum Number)) #`(xdr-encode-int (xdr-int #,field-access))]
      [(~datum Natural) #`(xdr-encode-uint (xdr-uint #,field-access))]
      [(~datum String) #`(xdr-encode-string (xdr-string #,field-access))]
      [(~datum Boolean) #`(xdr-encode-boolean (xdr-boolean #,field-access))]
      [(~datum Bytes) #`(xdr-encode-opaque (xdr-opaque #,field-access))]
      [(~datum Float) #`(xdr-encode-floating-point (xdr-floating-point #,field-access))]
      [(~datum Real) #`(xdr-encode-double (xdr-double-floating-point #,field-access))]
      [_ (raise-syntax-error
          #f
          (format "no encoder known for type: ~a" (syntax-e ty-stx))
          ty-stx)]))

  (define (decode-expr field-access ty-stx)
    (syntax-parse ty-stx
      [(~or (~datum Integer) (~datum Number)) #`(xdr-decode-int (xdr-int #,field-access))]
      [(~datum Natural) #`(xdr-decode-uint (xdr-uint #,field-access))]
      [(~datum String) #`(xdr-decode-string (xdr-string #,field-access))]
      [(~datum Boolean) #`(xdr-decode-boolean (xdr-boolean #,field-access))]
      [(~datum Bytes) #`(xdr-decode-opaque (xdr-opaque #,field-access))]
      [(~datum Float) #`(xdr-decode-floating-point (xdr-floating-point #,field-access))]
      [(~datum Real) #`(xdr-decode-double (xdr-double-floating-point #,field-access))]
      [_ (raise-syntax-error
          #f
          (format "no decoder known for type: ~a" (syntax-e ty-stx))
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
     #:with to-bytes-id (format-id #'name "~a-to-bytes" #'name)
     (define encode-exprs
       (for/list ([field (syntax->list #'(f.field ...))]
                  [type (syntax->list #'(f.type ...))])
         (encode-expr #`(#,(format-id #'name "~a-~a" #'name field) struct) type)))
     (define decode-exprs
       (for/list ([field (syntax->list #'(f.field ...))]
                  [type (syntax->list #'(f.type ...))])
         (decode-expr #`(#,(format-id #'name "~a-~a" #'name field) struct) type)))
     #`(begin
         ;; Struct definition
         (struct name ([f.field : f.type] ...))

         ;; Construct a struct with default values
         (: empty-id (-> name))
         (define (empty-id)
           (name f.zero ...))

         ;; Generate bytes from a struct
         (: to-bytes-id (-> name Bytes))
         (define (to-bytes-id struct)
           #,(quasisyntax (bytes-append #,@encode-exprs)))


         ;; Generate a struct from bytes
         ; (: from-bytes-id (-> Bytes name))
         ;  (define (from-bytes-id bstr)
         ;    #,(quasisyntax (bytes-append #,@encode-exprs))))
         )]))
;; ------------------------------------------------------------------