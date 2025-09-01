#lang typed/racket

(provide
 ;; XDR Signed Integer
 xdr-int xdr-int? xdr-int-number xdr-decode-int xdr-encode-int
 ;; XDR Unsigned Integer
 xdr-uint xdr-uint? xdr-uint-number xdr-decode-uint xdr-encode-uint)

;; XDR Signed Integer (32-bit)
;  An XDR signed integer is a 32-bit datum that encodes an integer in
;  the range [-2147483648,2147483647].  The integer is represented in
;  two's complement notation.  The most and least significant bytes are
;  0 and 3, respectively.  Integers are declared as follows:
;
;        int identifier;
;
;          (MSB)                   (LSB)
;        +-------+-------+-------+-------+
;        |byte 0 |byte 1 |byte 2 |byte 3 |                      INTEGER
;        +-------+-------+-------+-------+
;        <------------32 bits------------>
(struct xdr-int ([number : Integer]) #:transparent)

(: xdr-decode-int (-> Bytes xdr-int))
(define (xdr-decode-int bstr)
  (xdr-int (integer-bytes->integer bstr #t #t)))

(: xdr-encode-int (-> xdr-int Bytes))
(define (xdr-encode-int xdr-int)
  (integer->integer-bytes (xdr-int-number xdr-int) 4 #t #t))

;; XDR Unsigned Integer (32-bit)
;    An XDR unsigned integer is a 32-bit datum that encodes a non-negative
;    integer in the range [0,4294967295].  It is represented by an
;    unsigned binary number whose most and least significant bytes are 0
;    and 3, respectively.  An unsigned integer is declared as follows:
;
;        unsigned int identifier;
;
;            (MSB)                   (LSB)
;             +-------+-------+-------+-------+
;             |byte 0 |byte 1 |byte 2 |byte 3 |           UNSIGNED INTEGER
;             +-------+-------+-------+-------+
;             <------------32 bits------------>
(struct xdr-uint ([number : Integer]) #:transparent)

(: xdr-decode-uint (-> Bytes xdr-uint))
(define (xdr-decode-uint bstr)
  (xdr-uint (integer-bytes->integer bstr #f #t)))

(: xdr-encode-uint (-> xdr-uint Bytes))
(define (xdr-encode-uint xdr-uint)
  (integer->integer-bytes (xdr-uint-number xdr-uint) 4 #f #t))
