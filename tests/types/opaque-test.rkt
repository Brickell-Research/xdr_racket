#lang racket

(require rackunit
         rackunit/text-ui)
(require "../../xdr/types/opaque.rkt")

;; Variable-Length Opaque Constants as XDR Opaque Data
(define EMPTY_XDR_OPAQUE (xdr-opaque #""))
(define SINGLE_BYTE_XDR_OPAQUE (xdr-opaque #"\x42"))
(define FIVE_BYTE_XDR_OPAQUE (xdr-opaque #"\x42\x43\x44\x45\x46"))
(define BINARY_DATA_XDR_OPAQUE (xdr-opaque #"\x00\x01\x02\x03\xff\xfe\xfd"))

;; Variable-Length Opaque Constants as Encoded Bytes
(define EMPTY_OPAQUE_BYTES #"\x00\x00\x00\x00")
(define SINGLE_BYTE_OPAQUE_BYTES #"\x00\x00\x00\x01\x42\x00\x00\x00")
(define FIVE_BYTE_OPAQUE_BYTES #"\x00\x00\x00\x05\x42\x43\x44\x45\x46\x00\x00\x00")
(define BINARY_DATA_OPAQUE_BYTES #"\x00\x00\x00\x07\x00\x01\x02\x03\xff\xfe\xfd\x00")

;; Fixed-Length Opaque Constants as XDR Fixed Opaque Data
(define FIXED_1_BYTE_XDR_OPAQUE (xdr-fixed-opaque #"\x42" 1))
(define FIXED_4_BYTE_XDR_OPAQUE (xdr-fixed-opaque #"\x42\x43\x44\x45" 4))
(define FIXED_5_BYTE_XDR_OPAQUE (xdr-fixed-opaque #"\x42\x43\x44\x45\x46" 5))
(define FIXED_8_BYTE_XDR_OPAQUE (xdr-fixed-opaque #"\x00\x01\x02\x03\x04\x05\x06\x07" 8))

;; Fixed-Length Opaque Constants as Encoded Bytes (with padding)
(define FIXED_1_BYTE_OPAQUE_BYTES #"\x42\x00\x00\x00")
(define FIXED_4_BYTE_OPAQUE_BYTES #"\x42\x43\x44\x45")
(define FIXED_5_BYTE_OPAQUE_BYTES #"\x42\x43\x44\x45\x46\x00\x00\x00")
(define FIXED_8_BYTE_OPAQUE_BYTES #"\x00\x01\x02\x03\x04\x05\x06\x07")

(define opaque-tests
  (test-suite
   "XDR Opaque Data Tests"
   (test-suite "Variable-Length Opaque Data Decoding Tests"
               (check-equal? EMPTY_XDR_OPAQUE (xdr-decode-opaque EMPTY_OPAQUE_BYTES))
               (check-equal? SINGLE_BYTE_XDR_OPAQUE (xdr-decode-opaque SINGLE_BYTE_OPAQUE_BYTES))
               (check-equal? FIVE_BYTE_XDR_OPAQUE (xdr-decode-opaque FIVE_BYTE_OPAQUE_BYTES))
               (check-equal? BINARY_DATA_XDR_OPAQUE (xdr-decode-opaque BINARY_DATA_OPAQUE_BYTES)))
   (test-suite "Variable-Length Opaque Data Encoding Tests"
               (check-equal? EMPTY_OPAQUE_BYTES (xdr-encode-opaque EMPTY_XDR_OPAQUE))
               (check-equal? SINGLE_BYTE_OPAQUE_BYTES (xdr-encode-opaque SINGLE_BYTE_XDR_OPAQUE))
               (check-equal? FIVE_BYTE_OPAQUE_BYTES (xdr-encode-opaque FIVE_BYTE_XDR_OPAQUE))
               (check-equal? BINARY_DATA_OPAQUE_BYTES (xdr-encode-opaque BINARY_DATA_XDR_OPAQUE)))
   (test-suite "Fixed-Length Opaque Data Decoding Tests"
               (check-equal? FIXED_1_BYTE_XDR_OPAQUE (xdr-decode-fixed-opaque FIXED_1_BYTE_OPAQUE_BYTES 1))
               (check-equal? FIXED_4_BYTE_XDR_OPAQUE (xdr-decode-fixed-opaque FIXED_4_BYTE_OPAQUE_BYTES 4))
               (check-equal? FIXED_5_BYTE_XDR_OPAQUE (xdr-decode-fixed-opaque FIXED_5_BYTE_OPAQUE_BYTES 5))
               (check-equal? FIXED_8_BYTE_XDR_OPAQUE (xdr-decode-fixed-opaque FIXED_8_BYTE_OPAQUE_BYTES 8)))
   (test-suite "Fixed-Length Opaque Data Encoding Tests"
               (check-equal? FIXED_1_BYTE_OPAQUE_BYTES (xdr-encode-fixed-opaque FIXED_1_BYTE_XDR_OPAQUE))
               (check-equal? FIXED_4_BYTE_OPAQUE_BYTES (xdr-encode-fixed-opaque FIXED_4_BYTE_XDR_OPAQUE))
               (check-equal? FIXED_5_BYTE_OPAQUE_BYTES (xdr-encode-fixed-opaque FIXED_5_BYTE_XDR_OPAQUE))
               (check-equal? FIXED_8_BYTE_OPAQUE_BYTES (xdr-encode-fixed-opaque FIXED_8_BYTE_XDR_OPAQUE)))
   (test-suite "Fixed-Length Opaque Data Error Tests"
               (check-exn exn:fail? (lambda () (xdr-decode-fixed-opaque #"\x42" 5)))
               (check-exn exn:fail? (lambda () (xdr-encode-fixed-opaque (xdr-fixed-opaque #"\x42\x43" 1)))))
   ))

(run-tests opaque-tests)
