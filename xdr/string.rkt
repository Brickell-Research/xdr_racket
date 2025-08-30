#lang typed/racket

(require "internal/common.rkt")

(provide
 ;; XDR String
 xdr-string xdr-string? xdr-string-value xdr-decode-string xdr-encode-string)

;; XDR String
(struct xdr-string ([value : String]) #:transparent)

(: xdr-decode-string (-> Bytes xdr-string))
(define (xdr-decode-string bstr)
  (xdr-string (bytes->string/utf-8 (length-prefaced-bytes-deformat bstr))))

(: xdr-encode-string (-> xdr-string Bytes))
(define (xdr-encode-string xdr-string)
  (length-prefaced-bytes-format (string->bytes/utf-8 (xdr-string-value xdr-string))))
