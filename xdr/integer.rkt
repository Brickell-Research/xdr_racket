#lang typed/racket

(provide
 ;; XDR Signed Integer
 xdr-int xdr-int? xdr-int-number xdr-decode-int xdr-encode-int
 ;; XDR Unsigned Integer
 xdr-uint xdr-uint? xdr-uint-number xdr-decode-uint xdr-encode-uint)

;; XDR Signed Integer (32-bit)
(struct xdr-int ([number : Integer]) #:transparent)

(: xdr-decode-int (-> Bytes xdr-int))
(define (xdr-decode-int bstr)
  (xdr-int (integer-bytes->integer bstr #t #t)))

(: xdr-encode-int (-> xdr-int Bytes))
(define (xdr-encode-int xdr-int)
  (integer->integer-bytes (xdr-int-number xdr-int) 4 #t #t))

;; XDR Unsigned Integer (32-bit)
(struct xdr-uint ([number : Integer]) #:transparent)

(: xdr-decode-uint (-> Bytes xdr-uint))
(define (xdr-decode-uint bstr)
  (xdr-uint (integer-bytes->integer bstr #f #t)))

(: xdr-encode-uint (-> xdr-uint Bytes))
(define (xdr-encode-uint xdr-uint)
  (integer->integer-bytes (xdr-uint-number xdr-uint) 4 #f #t))
