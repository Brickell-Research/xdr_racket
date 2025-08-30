#lang racket

(require rackunit
         rackunit/text-ui)
(require "../xdr/opaque.rkt")

(provide opaque-tests)

;; Opaque Constants as XDR Opaque Data
(define EMPTY_XDR_OPAQUE (xdr-opaque #""))
(define SINGLE_BYTE_XDR_OPAQUE (xdr-opaque #"\x42"))
(define FIVE_BYTE_XDR_OPAQUE (xdr-opaque #"\x42\x43\x44\x45\x46"))
(define BINARY_DATA_XDR_OPAQUE (xdr-opaque #"\x00\x01\x02\x03\xff\xfe\xfd"))

;; Opaque Constants as Encoded Bytes
(define EMPTY_OPAQUE_BYTES #"\x00\x00\x00\x00")
(define SINGLE_BYTE_OPAQUE_BYTES #"\x00\x00\x00\x01\x42\x00\x00\x00")
(define FIVE_BYTE_OPAQUE_BYTES #"\x00\x00\x00\x05\x42\x43\x44\x45\x46\x00\x00\x00")
(define BINARY_DATA_OPAQUE_BYTES #"\x00\x00\x00\x07\x00\x01\x02\x03\xff\xfe\xfd\x00")

(define opaque-tests
  (test-suite
   "XDR Variable-Length Opaque Data Tests"
   (test-suite "Opaque Data Decoding Tests"
               (check-equal? EMPTY_XDR_OPAQUE (xdr-decode-opaque EMPTY_OPAQUE_BYTES))
               (check-equal? SINGLE_BYTE_XDR_OPAQUE (xdr-decode-opaque SINGLE_BYTE_OPAQUE_BYTES))
               (check-equal? FIVE_BYTE_XDR_OPAQUE (xdr-decode-opaque FIVE_BYTE_OPAQUE_BYTES))
               (check-equal? BINARY_DATA_XDR_OPAQUE (xdr-decode-opaque BINARY_DATA_OPAQUE_BYTES)))
   (test-suite "Opaque Data Encoding Tests"
               (check-equal? EMPTY_OPAQUE_BYTES (xdr-encode-opaque EMPTY_XDR_OPAQUE))
               (check-equal? SINGLE_BYTE_OPAQUE_BYTES (xdr-encode-opaque SINGLE_BYTE_XDR_OPAQUE))
               (check-equal? FIVE_BYTE_OPAQUE_BYTES (xdr-encode-opaque FIVE_BYTE_XDR_OPAQUE))
               (check-equal? BINARY_DATA_OPAQUE_BYTES (xdr-encode-opaque BINARY_DATA_XDR_OPAQUE)))))
