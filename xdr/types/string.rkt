#lang typed/racket

(require "../internal/common.rkt")

(provide
 ;; XDR String
 xdr-string xdr-string? xdr-string-value xdr-decode-string xdr-encode-string)

;; XDR String
;  The standard defines a string of n (numbered 0 through n-1) ASCII
;  bytes to be the number n encoded as an unsigned integer (as described
;  above), and followed by the n bytes of the string. Byte m of the
;  string always precedes byte m+1 of the string, and byte 0 of the
;  string always follows the string's length. If n is not a multiple of
;  four, then the n bytes are followed by enough (0 to 3) residual zero
;  bytes, r, to make the total byte count a multiple of four. Counted
;  byte strings are declared as follows:
;        string object<m>;
;     or
;        string object<>;
;
;  The constant m denotes an upper bound of the number of bytes that a
;  string may contain. If m is not specified, as in the second
;  declaration, it is assumed to be (2**32) - 1, the maximum length.
;
;           0     1     2     3     4     5   ...
;        +-----+-----+-----+-----+-----+-----+...+-----+-----+...+-----+
;        |        length n       |byte0|byte1|...| n-1 |  0  |...|  0  |
;        +-----+-----+-----+-----+-----+-----+...+-----+-----+...+-----+
;        |<-------4 bytes------->|<------n bytes------>|<---r bytes--->|
;                                |<----n+r (where (n+r) mod 4 = 0)---->|
;                                                                STRING
(struct xdr-string ([value : String]) #:transparent)

(: xdr-decode-string (-> Bytes xdr-string))
(define (xdr-decode-string bstr)
  (xdr-string (bytes->string/utf-8 (length-prefaced-bytes-deformat bstr))))

(: xdr-encode-string (-> xdr-string Bytes))
(define (xdr-encode-string xdr-string)
  (length-prefaced-bytes-format (string->bytes/utf-8 (xdr-string-value xdr-string))))
