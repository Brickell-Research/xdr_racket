#lang typed/racket

(provide
 ;; XDR String
 xdr-string xdr-string? xdr-string-value xdr-decode-string xdr-encode-string)

;; XDR String
(struct xdr-string ([value : String]) #:transparent)

(: padding-bytes (-> Integer Integer))
(define (padding-bytes n)
  (modulo (- 4 (modulo n 4)) 4))

(: xdr-decode-string (-> Bytes xdr-string))
(define (xdr-decode-string bstr)
  (define length (integer-bytes->integer (subbytes bstr 0 4) #f #t))
  (define string-bytes (subbytes bstr 4 (+ 4 length)))
  (xdr-string (bytes->string/utf-8 string-bytes)))

(: xdr-encode-string (-> xdr-string Bytes))
(define (xdr-encode-string xdr-string)
  (define string-bytes (string->bytes/utf-8 (xdr-string-value xdr-string)))
  (define length (bytes-length string-bytes))
  (define padding-count (padding-bytes length))
  (define length-bytes (integer->integer-bytes length 4 #f #t))
  (define padding (make-bytes padding-count 0))
  (bytes-append length-bytes string-bytes padding))
