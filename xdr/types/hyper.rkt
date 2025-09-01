#lang typed/racket

(provide
 ;; XDR Hyper Integer
 xdr-hyper xdr-hyper? xdr-hyper-number xdr-decode-hyper xdr-encode-hyper
 ;; XDR Unsigned Hyper Integer
 xdr-uhyper xdr-uhyper? xdr-uhyper-number xdr-decode-uhyper xdr-encode-uhyper)

;; XDR Hyper Integer (64-bit signed)
;  The standard also defines 64-bit (8-byte) numbers called hyper
;  integers and unsigned hyper integers. Their representations are the
;  obvious extensions of integer and unsigned integer defined above.
;  They are represented in two's complement notation. The most and
;  least significant bytes are 0 and 7, respectively. Their
;  declarations:
;
;        hyper identifier;
;        (MSB)                                                   (LSB)
;      +-------+-------+-------+-------+-------+-------+-------+-------+
;      |byte 0 |byte 1 |byte 2 |byte 3 |byte 4 |byte 5 |byte 6 |byte 7 |
;      +-------+-------+-------+-------+-------+-------+-------+-------+
;      <----------------------------64 bits---------------------------->
;                                                 HYPER INTEGER
(struct xdr-hyper ([number : Integer]) #:transparent)

(: xdr-decode-hyper (-> Bytes xdr-hyper))
(define (xdr-decode-hyper bstr)
  (xdr-hyper (integer-bytes->integer bstr #t #t)))

(: xdr-encode-hyper (-> xdr-hyper Bytes))
(define (xdr-encode-hyper xdr-hyper)
  (integer->integer-bytes (xdr-hyper-number xdr-hyper) 8 #t #t))

;; XDR Unsigned Hyper Integer (64-bit unsigned)
;  An XDR unsigned hyper integer is a 64-bit datum that encodes a
;  non-negative integer in the range [0,18446744073709551615]. It is
;  represented by an unsigned binary number whose most and least
;  significant bytes are 0 and 7, respectively. An unsigned hyper
;  integer is declared as follows:
;        unsigned hyper identifier;
;
;        (MSB)                                                   (LSB)
;      +-------+-------+-------+-------+-------+-------+-------+-------+
;      |byte 0 |byte 1 |byte 2 |byte 3 |byte 4 |byte 5 |byte 6 |byte 7 |
;      +-------+-------+-------+-------+-------+-------+-------+-------+
;      <----------------------------64 bits---------------------------->
;                                                 UNSIGNED HYPER INTEGER
(struct xdr-uhyper ([number : Integer]) #:transparent)

(: xdr-decode-uhyper (-> Bytes xdr-uhyper))
(define (xdr-decode-uhyper bstr)
  (xdr-uhyper (integer-bytes->integer bstr #f #t)))

(: xdr-encode-uhyper (-> xdr-uhyper Bytes))
(define (xdr-encode-uhyper xdr-uhyper)
  (integer->integer-bytes (xdr-uhyper-number xdr-uhyper) 8 #f #t))
