#lang typed/racket

(provide xdr-enum xdr-enum? xdr-enum-value-from-key xdr-enum-key-from-value xdr-enum-encode xdr-enum-decode)

;; XDR Enum
;  Enumerations have the same representation as signed integers.
;  Enumerations are handy for describing subsets of the integers.
;  Enumerated data is declared as follows:
;
;        enum { name-identifier = constant, ... } identifier;
;
;  For example, the three colors red, yellow, and blue could be
;  described by an enumerated type:
;
;        enum { RED = 2, YELLOW = 3, BLUE = 5 } colors;
;
;  It is an error to encode as an enum any integer other than those that
;  have been given assignments in the enum declaration.

(struct xdr-enum ([values : (Listof (Pairof Symbol Integer))]))

;; Fetch the value of an enum from its key.
(: xdr-enum-value-from-key (-> xdr-enum Symbol Integer))
(define (xdr-enum-value-from-key enum key)
  (: possible-value (U (Pairof Symbol Integer) False))
  (define possible-value (assoc key (xdr-enum-values enum)))
  (cond
    [(not possible-value) (error "Key not found in enum")]
    [else (cdr possible-value)]))

;; Fetch the key of an enum from its value.
(: xdr-enum-key-from-value (-> xdr-enum Integer Symbol))
(define (xdr-enum-key-from-value enum value)
  (: helper (-> (Listof (Pairof Symbol Integer)) Integer Symbol))
  (define (helper xs value)
    (cond
      [(empty? xs) (error "Value not found in enum")]
      [(eq? value (cdr (first xs))) (car (first xs))]
      [else (helper (rest xs) value)]))
  (helper (xdr-enum-values enum) value))

;; Encode an enum to bytes.
(: xdr-enum-encode (-> xdr-enum Symbol Bytes))
(define (xdr-enum-encode enum key)
  (define value (xdr-enum-value-from-key enum key))
  (if (integer? value)
      (integer->integer-bytes value 4 #f #t)
      (error "Key not found in enum")))

;; Decode bytes to an enum.
(: xdr-enum-decode (-> xdr-enum Bytes Symbol))
(define (xdr-enum-decode enum bytes)
  (define value (integer-bytes->integer bytes #f #t))
  (define possible-value (xdr-enum-key-from-value enum value))
  (cond
    [(not possible-value) (error "Value not found in enum")]
    [else possible-value]))
