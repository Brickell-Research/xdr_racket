#lang racket

(require rackunit
         rackunit/text-ui)
(require "main.rkt")

(define encode-tests
  (test-suite
   "XDR Encoding Tests"
   (check-equal? (xdr-encode "hello") #"hello")
   (check-equal? (xdr-encode "world") #"world")
   (check-equal? (xdr-encode "") #"")))

(define decode-tests
  (test-suite
   "XDR Decoding Tests"
   (check-equal? (xdr-decode #"hello") "hello")
   (check-equal? (xdr-decode #"world") "world")
   (check-equal? (xdr-decode #"") "")))

(define round-trip-tests
  (test-suite
   "XDR Round-trip Tests"
   (check-equal? (xdr-decode (xdr-encode "test")) "test")
   (check-equal? (xdr-decode (xdr-encode "racket")) "racket")
   (check-equal? (xdr-decode (xdr-encode "XDR")) "XDR")))

(define all-tests
  (test-suite
   "XDR Library Tests"
   encode-tests
   decode-tests
   round-trip-tests))

(run-tests all-tests)
