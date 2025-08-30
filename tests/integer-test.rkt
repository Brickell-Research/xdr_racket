#lang racket

(require rackunit
         rackunit/text-ui)
(require "../xdr/integer.rkt")

;; Integer Constants as XDR Integers
(define ZERO_XDR_INT (xdr-int 0))
(define ONE_XDR_INT (xdr-int 1))
(define NEGATIVE_ONE_XDR_INT (xdr-int -1))
(define MAX_XDR_INT (xdr-int 2147483647))
(define MIN_XDR_INT (xdr-int -2147483648))

;; Integer Constants as Bytes
(define ZERO_INT_BYTES #"\x00\x00\x00\x00")
(define ONE_INT_BYTES #"\x00\x00\x00\x01")
(define NEGATIVE_ONE_INT_BYTES #"\xff\xff\xff\xff")
(define MAX_INT_BYTES #"\x7f\xff\xff\xff")
(define MIN_INT_BYTES #"\x80\x00\x00\x00")

;; Unsigned Integer Constants as XDR Integers
(define ZERO_UNSIGNED_XDR_INT (xdr-uint 0))
(define ONE_UNSIGNED_XDR_INT (xdr-uint 1))
(define MAX_UNSIGNED_XDR_INT (xdr-uint 4294967295))

;; Unsigned Integer Constants as Bytes
(define ZERO_UNSIGNED_INT_BYTES #"\x00\x00\x00\x00")
(define ONE_UNSIGNED_INT_BYTES #"\x00\x00\x00\x01")
(define MAX_UNSIGNED_INT_BYTES #"\xff\xff\xff\xff")

(define integer-tests
  (test-suite
   "XDR Integer Tests"
   (test-suite "Integer Decoding Tests"
               ;; 32-bit signed integer
               ;; base
               (check-equal? ZERO_XDR_INT (xdr-decode-int ZERO_INT_BYTES))
               ;; positive
               (check-equal? ONE_XDR_INT (xdr-decode-int ONE_INT_BYTES))
               ;; negative
               (check-equal? NEGATIVE_ONE_XDR_INT (xdr-decode-int NEGATIVE_ONE_INT_BYTES))
               ;; max positive
               (check-equal? MAX_XDR_INT (xdr-decode-int MAX_INT_BYTES))
               ;; min negative
               (check-equal? MIN_XDR_INT (xdr-decode-int MIN_INT_BYTES)))
   (test-suite "Unsigned Integer Decoding Tests"
               ;; 32-bit unsigned integer
               ;; base
               (check-equal? ZERO_UNSIGNED_XDR_INT (xdr-decode-uint ZERO_UNSIGNED_INT_BYTES))
               ;; positive
               (check-equal? ONE_UNSIGNED_XDR_INT (xdr-decode-uint ONE_UNSIGNED_INT_BYTES))
               ;; max positive
               (check-equal? MAX_UNSIGNED_XDR_INT (xdr-decode-uint MAX_UNSIGNED_INT_BYTES)))
   (test-suite "Integer Encoding Tests"
               ;; 32-bit signed integer
               ;; base
               (check-equal? ZERO_INT_BYTES (xdr-encode-int ZERO_XDR_INT))
               ;; positive
               (check-equal? ONE_INT_BYTES (xdr-encode-int ONE_XDR_INT))
               ;; negative
               (check-equal? NEGATIVE_ONE_INT_BYTES (xdr-encode-int NEGATIVE_ONE_XDR_INT))
               ;; max positive
               (check-equal? MAX_INT_BYTES (xdr-encode-int MAX_XDR_INT))
               ;; min negative
               (check-equal? MIN_INT_BYTES (xdr-encode-int MIN_XDR_INT)))
   (test-suite "Unsigned Integer Encoding Tests"
               ;; 32-bit unsigned integer
               ;; base
               (check-equal? ZERO_UNSIGNED_INT_BYTES (xdr-encode-uint ZERO_UNSIGNED_XDR_INT))
               ;; positive
               (check-equal? ONE_UNSIGNED_INT_BYTES (xdr-encode-uint ONE_UNSIGNED_XDR_INT))
               ;; max positive
               (check-equal? MAX_UNSIGNED_INT_BYTES (xdr-encode-uint MAX_UNSIGNED_XDR_INT)))))

(run-tests integer-tests)
