#lang racket

(require rackunit
         rackunit/text-ui)
(require "../xdr/boolean.rkt")

(provide boolean-tests)

;; Boolean Constants as XDR Booleans
(define FALSE_XDR_BOOLEAN (xdr-boolean #f))
(define TRUE_XDR_BOOLEAN (xdr-boolean #t))

;; We need integer bytes for boolean tests since booleans encode as 4-byte integers
(define ZERO_INT_BYTES #"\x00\x00\x00\x00")
(define ONE_INT_BYTES #"\x00\x00\x00\x01")

(define boolean-tests
  (test-suite
   "XDR Boolean Tests"
   (test-suite "Boolean Decoding Tests"
               ;; base
               (check-equal? FALSE_XDR_BOOLEAN (xdr-decode-boolean ZERO_INT_BYTES))
               ;; true
               (check-equal? TRUE_XDR_BOOLEAN (xdr-decode-boolean ONE_INT_BYTES)))
   (test-suite "Boolean Encoding Tests"
               ;; base
               (check-equal? ZERO_INT_BYTES (xdr-encode-boolean FALSE_XDR_BOOLEAN))
               ;; true
               (check-equal? ONE_INT_BYTES (xdr-encode-boolean TRUE_XDR_BOOLEAN)))))
