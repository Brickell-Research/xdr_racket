#lang typed/racket

(provide
 ;; XDR Boolean
 xdr-boolean xdr-boolean? xdr-boolean-value xdr-decode-boolean xdr-encode-boolean)

;; XDR Boolean
(struct xdr-boolean ([value : Boolean]) #:transparent)

(: xdr-decode-boolean (-> Bytes xdr-boolean))
(define (xdr-decode-boolean bstr)
  (xdr-boolean (equal? 1 (integer-bytes->integer bstr #f #t))))

(: xdr-encode-boolean (-> xdr-boolean Bytes))
(define (xdr-encode-boolean xdr-boolean)
  (integer->integer-bytes
   (cond
     [(xdr-boolean-value xdr-boolean) 1]
     [else 0])
   4 #t #t))
