#lang racket

(require rackunit
         rackunit/text-ui)
(require "../xdr/string.rkt")

(provide string-tests)

;; String Constants as XDR Strings
(define EMPTY_XDR_STRING (xdr-string ""))
(define SINGLE_A_XDR_STRING (xdr-string "A"))
(define DOUBLE_A_XDR_STRING (xdr-string "AA"))
(define THREE_CHAR_XDR_STRING (xdr-string "ABC"))
(define WEIRD_ASCII_XDR_STRING (xdr-string "@#$"))

;; String Constants as Bytes
(define EMPTY_STRING_BYTES #"\x00\x00\x00\x00")
(define SINGLE_A_STRING_BYTES #"\x00\x00\x00\x01A\x00\x00\x00")
(define DOUBLE_A_STRING_BYTES #"\x00\x00\x00\x02AA\x00\x00")
(define THREE_CHAR_STRING_BYTES #"\x00\x00\x00\x03ABC\x00")
(define WEIRD_ASCII_STRING_BYTES #"\x00\x00\x00\x03@#$\x00")

(define string-tests
  (test-suite
   "XDR String Tests"
   (test-suite "String Decoding Tests"
               ;; empty string
               (check-equal? EMPTY_XDR_STRING (xdr-decode-string EMPTY_STRING_BYTES))
               ;; single A
               (check-equal? SINGLE_A_XDR_STRING (xdr-decode-string SINGLE_A_STRING_BYTES))
               ;; double AA
               (check-equal? DOUBLE_A_XDR_STRING (xdr-decode-string DOUBLE_A_STRING_BYTES))
               ;; three chars with padding
               (check-equal? THREE_CHAR_XDR_STRING (xdr-decode-string THREE_CHAR_STRING_BYTES))
               ;; weird ASCII chars
               (check-equal? WEIRD_ASCII_XDR_STRING (xdr-decode-string WEIRD_ASCII_STRING_BYTES)))
   (test-suite "String Encoding Tests"
               ;; empty string
               (check-equal? EMPTY_STRING_BYTES (xdr-encode-string EMPTY_XDR_STRING))
               ;; single A
               (check-equal? SINGLE_A_STRING_BYTES (xdr-encode-string SINGLE_A_XDR_STRING))
               ;; double AA
               (check-equal? DOUBLE_A_STRING_BYTES (xdr-encode-string DOUBLE_A_XDR_STRING))
               ;; three chars with padding
               (check-equal? THREE_CHAR_STRING_BYTES (xdr-encode-string THREE_CHAR_XDR_STRING))
               ;; weird ASCII chars
               (check-equal? WEIRD_ASCII_STRING_BYTES (xdr-encode-string WEIRD_ASCII_XDR_STRING)))))


(run-tests string-tests)