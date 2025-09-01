#lang racket

(require rackunit
         rackunit/text-ui)
(require "../../xdr/types/void.rkt")

;; Constants as Bytes
(define EMPTY_BYTES #"")
(define ZERO_BYTES #"\x00\x00\x00\x00")
(define ONE_BYTES #"\x00\x00\x00\x01")
(define TWO_BYTES #"\x00\x00\x00\x02")

;; Void Constant as XDR Void
(define EMPTY_XDR_VOID (xdr-void))

(define void-tests
  (test-suite
   "XDR Void Tests"
   (test-suite "Void Decoding Tests"
               (check-equal? (void) (xdr-decode-void EMPTY_BYTES))
               (check-equal? (void) (xdr-decode-void ZERO_BYTES))
               (check-equal? (void) (xdr-decode-void ONE_BYTES))
               (check-equal? (void) (xdr-decode-void TWO_BYTES)))
   (test-suite "Void Encoding Tests"
               (check-equal? EMPTY_BYTES (xdr-encode-void (void))))))

(run-tests void-tests)