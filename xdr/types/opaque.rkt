#lang typed/racket

(require "../internal/common.rkt")

(provide
 ;; XDR Variable-Length Opaque Data
 xdr-opaque xdr-opaque? xdr-opaque-data xdr-decode-opaque xdr-encode-opaque
 ;; XDR Fixed-Length Opaque Data
 xdr-fixed-opaque xdr-fixed-opaque? xdr-fixed-opaque-data xdr-fixed-opaque-length
 xdr-decode-fixed-opaque xdr-encode-fixed-opaque)

;; XDR Variable-Length Opaque Data
;  The standard also provides for variable-length (counted) opaque data,
;  defined as a sequence of n (numbered 0 through n-1) arbitrary bytes
;  to be the number n encoded as an unsigned integer (as described
;  below), and followed by the n bytes of the sequence.
;
;  Byte m of the sequence always precedes byte m+1 of the sequence, and
;  byte 0 of the sequence always follows the sequence's length (count).
;  If n is not a multiple of four, then the n bytes are followed by
;  enough (0 to 3) residual zero bytes, r, to make the total byte count
;  a multiple of four. Variable-length opaque data is declared in the
;  following way:
;        opaque identifier<m>;
;     or
;        opaque identifier<>;
;
;           0     1     2     3     4     5   ...
;        +-----+-----+-----+-----+-----+-----+...+-----+-----+...+-----+
;        |        length n       |byte0|byte1|...| n-1 |  0  |...|  0  |
;        +-----+-----+-----+-----+-----+-----+...+-----+-----+...+-----+
;        |<-------4 bytes------->|<------n bytes------>|<---r bytes--->|
;                                |<----n+r (where (n+r) mod 4 = 0)---->|
;                                                 VARIABLE-LENGTH OPAQUE
(struct xdr-opaque ([data : Bytes]) #:transparent)

(: xdr-decode-opaque (-> Bytes xdr-opaque))
(define (xdr-decode-opaque bstr)
  (xdr-opaque (length-prefaced-bytes-deformat bstr)))

(: xdr-encode-opaque (-> xdr-opaque Bytes))
(define (xdr-encode-opaque xdr-opaque)
  (length-prefaced-bytes-format (xdr-opaque-data xdr-opaque)))

;; XDR Fixed-Length Opaque Data
;  At times, fixed-length uninterpreted data needs to be passed among
;  machines. This data is called "opaque" and is declared as follows:
;        opaque identifier[n];
;
;  where the constant n is the (static) number of bytes necessary to
;  contain the opaque data. If n is not a multiple of four, then the n
;  bytes are followed by enough (0 to 3) residual zero bytes, r, to make
;  the total byte count of the opaque object a multiple of four.
;
;         0        1     ...
;     +--------+--------+...+--------+--------+...+--------+
;     | byte 0 | byte 1 |...|byte n-1|    0   |...|    0   |
;     +--------+--------+...+--------+--------+...+--------+
;     |<-----------n bytes---------->|<------r bytes------>|
;     |<-----------n+r (where (n+r) mod 4 = 0)------------>|
;                                              FIXED-LENGTH OPAQUE
(struct xdr-fixed-opaque ([data : Bytes] [length : Integer]) #:transparent)

(: xdr-decode-fixed-opaque (-> Bytes Integer xdr-fixed-opaque))
(define (xdr-decode-fixed-opaque bstr n)
  (assert (>= (bytes-length bstr) (+ n (padding-bytes n))))
  (define data (subbytes bstr 0 n))
  (xdr-fixed-opaque data n))

(: xdr-encode-fixed-opaque (-> xdr-fixed-opaque Bytes))
(define (xdr-encode-fixed-opaque fixed-opaque)
  (define data (xdr-fixed-opaque-data fixed-opaque))
  (define n (xdr-fixed-opaque-length fixed-opaque))
  (assert (= (bytes-length data) n))
  (define padding-count (padding-bytes n))
  (define padding (make-bytes padding-count 0))
  (bytes-append data padding))

(module test racket/base)
