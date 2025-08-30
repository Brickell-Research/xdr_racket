#lang racket

(require rackunit
         rackunit/text-ui)
(require "../xdr/floating-point.rkt")

;; Single Precision Floating Point Constants as XDR Floating Points
(define NEGATIVE_ZERO_XDR_FLOAT (xdr-floating-point -0.0))
(define ONE_XDR_FLOAT (xdr-floating-point 1.0))
(define NEGATIVE_ONE_XDR_FLOAT (xdr-floating-point -1.0))

;; Single Precision Floating Point Constants as Bytes
(define NEGATIVE_ZERO_FLOAT_BYTES #"\x80\x00\x00\x00")
(define ONE_FLOAT_BYTES #"\x3f\x80\x00\x00")
(define NEGATIVE_ONE_FLOAT_BYTES #"\xbf\x80\x00\x00")

;; Double Precision Floating Point Constants as XDR Doubles
(define NEGATIVE_ZERO_XDR_DOUBLE (xdr-double-floating-point -0.0))
(define ONE_XDR_DOUBLE (xdr-double-floating-point 1.0))
(define NEGATIVE_ONE_XDR_DOUBLE (xdr-double-floating-point -1.0))
(define TWO_XDR_DOUBLE (xdr-double-floating-point 2.0))

;; Double Precision Floating Point Constants as Bytes
(define NEGATIVE_ZERO_DOUBLE_BYTES #"\x80\x00\x00\x00\x00\x00\x00\x00")
(define ONE_DOUBLE_BYTES #"\x3f\xf0\x00\x00\x00\x00\x00\x00")
(define NEGATIVE_ONE_DOUBLE_BYTES #"\xbf\xf0\x00\x00\x00\x00\x00\x00")
(define TWO_DOUBLE_BYTES #"\x40\x00\x00\x00\x00\x00\x00\x00")

;; Quadruple Precision Floating Point Constants as XDR Quadruples
(define NEGATIVE_ZERO_XDR_QUADRUPLE (xdr-quadruple-floating-point -0.0))
(define ONE_XDR_QUADRUPLE (xdr-quadruple-floating-point 1.0))
(define NEGATIVE_ONE_XDR_QUADRUPLE (xdr-quadruple-floating-point -1.0))

;; Quadruple Precision Floating Point Constants as Bytes (16 bytes with double precision + padding)
(define NEGATIVE_ZERO_QUADRUPLE_BYTES #"\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00")
(define ONE_QUADRUPLE_BYTES #"\x3f\xf0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00")
(define NEGATIVE_ONE_QUADRUPLE_BYTES #"\xbf\xf0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00")

(define floating-point-tests
  (test-suite
   "XDR Floating Point Tests"
   (test-suite "Single Precision Decoding Tests"
               (check-equal? NEGATIVE_ZERO_XDR_FLOAT (xdr-decode-floating-point NEGATIVE_ZERO_FLOAT_BYTES))
               (check-equal? ONE_XDR_FLOAT (xdr-decode-floating-point ONE_FLOAT_BYTES))
               (check-equal? NEGATIVE_ONE_XDR_FLOAT (xdr-decode-floating-point NEGATIVE_ONE_FLOAT_BYTES)))
   (test-suite "Double Precision Decoding Tests"
               (check-equal? NEGATIVE_ZERO_XDR_DOUBLE (xdr-decode-double NEGATIVE_ZERO_DOUBLE_BYTES))
               (check-equal? ONE_XDR_DOUBLE (xdr-decode-double ONE_DOUBLE_BYTES))
               (check-equal? NEGATIVE_ONE_XDR_DOUBLE (xdr-decode-double NEGATIVE_ONE_DOUBLE_BYTES))
               (check-equal? TWO_XDR_DOUBLE (xdr-decode-double TWO_DOUBLE_BYTES)))
   (test-suite "Quadruple Precision Decoding Tests"
               (check-exn exn:fail? (lambda () (xdr-decode-quadruple NEGATIVE_ZERO_QUADRUPLE_BYTES)))
               (check-exn exn:fail? (lambda () (xdr-decode-quadruple ONE_QUADRUPLE_BYTES)))
               (check-exn exn:fail? (lambda () (xdr-decode-quadruple NEGATIVE_ONE_QUADRUPLE_BYTES))))
   (test-suite "Single Precision Encoding Tests"
               (check-equal? NEGATIVE_ZERO_FLOAT_BYTES (xdr-encode-floating-point NEGATIVE_ZERO_XDR_FLOAT))
               (check-equal? ONE_FLOAT_BYTES (xdr-encode-floating-point ONE_XDR_FLOAT))
               (check-equal? NEGATIVE_ONE_FLOAT_BYTES (xdr-encode-floating-point NEGATIVE_ONE_XDR_FLOAT)))
   (test-suite "Double Precision Encoding Tests"
               (check-equal? NEGATIVE_ZERO_DOUBLE_BYTES (xdr-encode-double NEGATIVE_ZERO_XDR_DOUBLE))
               (check-equal? NEGATIVE_ONE_DOUBLE_BYTES (xdr-encode-double NEGATIVE_ONE_XDR_DOUBLE))
               (check-equal? TWO_DOUBLE_BYTES (xdr-encode-double TWO_XDR_DOUBLE)))
   (test-suite "Quadruple Precision Encoding Tests"
               (check-exn exn:fail? (lambda () (xdr-encode-quadruple NEGATIVE_ZERO_XDR_QUADRUPLE)))
               (check-exn exn:fail? (lambda () (xdr-encode-quadruple ONE_XDR_QUADRUPLE)))
               (check-exn exn:fail? (lambda () (xdr-encode-quadruple NEGATIVE_ONE_XDR_QUADRUPLE))))
   (test-suite "Input Validation Tests"
               (check-exn exn:fail? (lambda () (xdr-decode-floating-point #"\x3f\x80\x00")))
               (check-exn exn:fail? (lambda () (xdr-decode-floating-point #"\x3f\x80\x00\x00\x00")))
               (check-exn exn:fail? (lambda () (xdr-decode-double #"\x3f\xf0\x00\x00")))
               (check-exn exn:fail? (lambda () (xdr-decode-double #"\x3f\xf0\x00\x00\x00\x00\x00\x00\x00")))
               (check-exn exn:fail? (lambda () (xdr-decode-quadruple #"\x3f\xf0\x00\x00\x00\x00\x00\x00")))
               (check-exn exn:fail? (lambda () (xdr-decode-quadruple #"\x3f\xf0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"))))))

(run-tests floating-point-tests)
