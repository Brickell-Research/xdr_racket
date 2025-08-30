#lang typed/racket

(require "internal/common.rkt")

(provide
 ;; XDR Variable-Length Opaque Data
 xdr-opaque xdr-opaque? xdr-opaque-data xdr-decode-opaque xdr-encode-opaque
 ;; XDR Fixed-Length Opaque Data
 xdr-fixed-opaque xdr-fixed-opaque? xdr-fixed-opaque-data xdr-fixed-opaque-length
 xdr-decode-fixed-opaque xdr-encode-fixed-opaque)

;; XDR Variable-Length Opaque Data
(struct xdr-opaque ([data : Bytes]) #:transparent)

(: xdr-decode-opaque (-> Bytes xdr-opaque))
(define (xdr-decode-opaque bstr)
  (xdr-opaque (length-prefaced-bytes-deformat bstr)))

(: xdr-encode-opaque (-> xdr-opaque Bytes))
(define (xdr-encode-opaque xdr-opaque)
  (length-prefaced-bytes-format (xdr-opaque-data xdr-opaque)))

;; XDR Fixed-Length Opaque Data
(struct xdr-fixed-opaque ([data : Bytes] [length : Integer]) #:transparent)

(: xdr-decode-fixed-opaque (-> Bytes Integer xdr-fixed-opaque))
(define (xdr-decode-fixed-opaque bstr n)
  (assert (>= (bytes-length bstr) (+ n (padding-bytes n))))
  (define data (subbytes bstr 0 n))
  (xdr-fixed-opaque data n))

(: xdr-encode-fixed-opaque (-> xdr-fixed-opaque Bytes))
(define (xdr-encode-fixed-opaque fixed-opaque)
  (define data (xdr-fixed-opaque-data fixed-opaque))
  (define n (xdr-fixed-opaque-length fixed-opaque))
  (assert (= (bytes-length data) n))
  (define padding-count (padding-bytes n))
  (define padding (make-bytes padding-count 0))
  (bytes-append data padding))

(module test racket/base)
