#lang typed/racket

(provide
 ;; XDR Hyper Integer
 xdr-hyper xdr-hyper? xdr-hyper-number xdr-decode-hyper xdr-encode-hyper
 ;; XDR Unsigned Hyper Integer
 xdr-uhyper xdr-uhyper? xdr-uhyper-number xdr-decode-uhyper xdr-encode-uhyper)

;; XDR Hyper Integer (64-bit signed)
(struct xdr-hyper ([number : Integer]) #:transparent)

(: xdr-decode-hyper (-> Bytes xdr-hyper))
(define (xdr-decode-hyper bstr)
  (xdr-hyper (integer-bytes->integer bstr #t #t)))

(: xdr-encode-hyper (-> xdr-hyper Bytes))
(define (xdr-encode-hyper xdr-hyper)
  (integer->integer-bytes (xdr-hyper-number xdr-hyper) 8 #t #t))

;; XDR Unsigned Hyper Integer (64-bit unsigned)
(struct xdr-uhyper ([number : Integer]) #:transparent)

(: xdr-decode-uhyper (-> Bytes xdr-uhyper))
(define (xdr-decode-uhyper bstr)
  (xdr-uhyper (integer-bytes->integer bstr #f #t)))

(: xdr-encode-uhyper (-> xdr-uhyper Bytes))
(define (xdr-encode-uhyper xdr-uhyper)
  (integer->integer-bytes (xdr-uhyper-number xdr-uhyper) 8 #f #t))
