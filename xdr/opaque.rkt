#lang typed/racket

(require "internal/common.rkt")

(provide
 ;; XDR Variable-Length Opaque Data
 xdr-opaque xdr-opaque? xdr-opaque-data xdr-decode-opaque xdr-encode-opaque)

;; XDR Variable-Length Opaque Data
(struct xdr-opaque ([data : Bytes]) #:transparent)

(: xdr-decode-opaque (-> Bytes xdr-opaque))
(define (xdr-decode-opaque bstr)
  (xdr-opaque (length-prefaced-bytes-deformat bstr)))

(: xdr-encode-opaque (-> xdr-opaque Bytes))
(define (xdr-encode-opaque xdr-opaque)
  (length-prefaced-bytes-format (xdr-opaque-data xdr-opaque)))

(module test racket/base)
