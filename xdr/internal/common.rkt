#lang typed/racket

(provide padding-bytes length-prefaced-bytes-format length-prefaced-bytes-deformat list-encode)

(: padding-bytes (-> Integer Integer))
(define (padding-bytes n)
  (modulo (- 4 (modulo n 4)) 4))

(: length-prefaced-bytes-format (-> Bytes Bytes))
(define (length-prefaced-bytes-format bstr)
  (define length (bytes-length bstr))
  (define padding-count (padding-bytes length))
  (define length-bytes (integer->integer-bytes length 4 #f #t))
  (define padding (make-bytes padding-count 0))
  (bytes-append length-bytes bstr padding))

(: length-prefaced-bytes-deformat (-> Bytes Bytes))
(define (length-prefaced-bytes-deformat bstr)
  (define length (integer-bytes->integer (subbytes bstr 0 4) #f #t))
  (subbytes bstr 4 (+ 4 length)))

(: list-encode (All (A) (-> (Listof A) (-> A Bytes) Bytes)))
(define (list-encode lst encode-fn)
  (apply bytes-append (map encode-fn lst)))

