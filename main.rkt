#lang typed/racket

(provide
 ;; XDR Integer
 xdr-int xdr-int? xdr-int-number xdr-decode-int xdr-encode-int)

(struct xdr-int ([number : Integer]) #:transparent)

(: xdr-decode-int (-> Bytes xdr-int))
(define (xdr-decode-int bstr)
  (xdr-int (integer-bytes->integer bstr #t #t)))

(: xdr-encode-int (-> xdr-int Bytes))
(define (xdr-encode-int xdr-int)
  (integer->integer-bytes (xdr-int-number xdr-int) 4 #t #t))
