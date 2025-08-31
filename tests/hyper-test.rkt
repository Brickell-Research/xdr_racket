#lang racket

(require rackunit
         rackunit/text-ui)
(require "../xdr/hyper.rkt")

;; Hyper Integer Constants as XDR Hyper Integers
(define ZERO_XDR_HYPER (xdr-hyper 0))
(define ONE_XDR_HYPER (xdr-hyper 1))
(define NEGATIVE_ONE_XDR_HYPER (xdr-hyper -1))
(define MAX_XDR_HYPER (xdr-hyper 9223372036854775807))
(define MIN_XDR_HYPER (xdr-hyper -9223372036854775808))

;; Hyper Integer Constants as Bytes
(define ZERO_HYPER_BYTES #"\x00\x00\x00\x00\x00\x00\x00\x00")
(define ONE_HYPER_BYTES #"\x00\x00\x00\x00\x00\x00\x00\x01")
(define NEGATIVE_ONE_HYPER_BYTES #"\xff\xff\xff\xff\xff\xff\xff\xff")
(define MAX_HYPER_BYTES #"\x7f\xff\xff\xff\xff\xff\xff\xff")
(define MIN_HYPER_BYTES #"\x80\x00\x00\x00\x00\x00\x00\x00")

;; Unsigned Hyper Integer Constants as XDR Unsigned Hyper Integers
(define ZERO_UNSIGNED_XDR_HYPER (xdr-uhyper 0))
(define ONE_UNSIGNED_XDR_HYPER (xdr-uhyper 1))
(define MAX_UNSIGNED_XDR_HYPER (xdr-uhyper 18446744073709551615))

;; Unsigned Hyper Integer Constants as Bytes
(define ZERO_UNSIGNED_HYPER_BYTES #"\x00\x00\x00\x00\x00\x00\x00\x00")
(define ONE_UNSIGNED_HYPER_BYTES #"\x00\x00\x00\x00\x00\x00\x00\x01")
(define MAX_UNSIGNED_HYPER_BYTES #"\xff\xff\xff\xff\xff\xff\xff\xff")

(define hyper-tests
  (test-suite
   "XDR Hyper Integer Tests"
   (test-suite "Hyper Integer Decoding Tests"
               (check-equal? ZERO_XDR_HYPER (xdr-decode-hyper ZERO_HYPER_BYTES))
               (check-equal? ONE_XDR_HYPER (xdr-decode-hyper ONE_HYPER_BYTES))
               (check-equal? NEGATIVE_ONE_XDR_HYPER (xdr-decode-hyper NEGATIVE_ONE_HYPER_BYTES))
               (check-equal? MAX_XDR_HYPER (xdr-decode-hyper MAX_HYPER_BYTES))
               (check-equal? MIN_XDR_HYPER (xdr-decode-hyper MIN_HYPER_BYTES)))
   (test-suite "Unsigned Hyper Integer Decoding Tests"
               (check-equal? ZERO_UNSIGNED_XDR_HYPER (xdr-decode-uhyper ZERO_UNSIGNED_HYPER_BYTES))
               (check-equal? ONE_UNSIGNED_XDR_HYPER (xdr-decode-uhyper ONE_UNSIGNED_HYPER_BYTES))
               (check-equal? MAX_UNSIGNED_XDR_HYPER (xdr-decode-uhyper MAX_UNSIGNED_HYPER_BYTES)))
   (test-suite "Hyper Integer Encoding Tests"
               (check-equal? ZERO_HYPER_BYTES (xdr-encode-hyper ZERO_XDR_HYPER))
               (check-equal? ONE_HYPER_BYTES (xdr-encode-hyper ONE_XDR_HYPER))
               (check-equal? NEGATIVE_ONE_HYPER_BYTES (xdr-encode-hyper NEGATIVE_ONE_XDR_HYPER))
               (check-equal? MAX_HYPER_BYTES (xdr-encode-hyper MAX_XDR_HYPER))
               (check-equal? MIN_HYPER_BYTES (xdr-encode-hyper MIN_XDR_HYPER)))
   (test-suite "Unsigned Hyper Integer Encoding Tests"
               (check-equal? ZERO_UNSIGNED_HYPER_BYTES (xdr-encode-uhyper ZERO_UNSIGNED_XDR_HYPER))
               (check-equal? ONE_UNSIGNED_HYPER_BYTES (xdr-encode-uhyper ONE_UNSIGNED_XDR_HYPER))
               (check-equal? MAX_UNSIGNED_HYPER_BYTES (xdr-encode-uhyper MAX_UNSIGNED_XDR_HYPER)))))

(run-tests hyper-tests)
