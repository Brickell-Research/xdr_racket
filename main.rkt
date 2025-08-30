#lang racket/base

(require racket/contract)

(provide (contract-out
          [xdr-encode (-> string? bytes?)]
          [xdr-decode (-> bytes? string?)]))

(define (xdr-encode str)
  (string->bytes/utf-8 str))

(define (xdr-decode str)
  (bytes->string/utf-8 str))
