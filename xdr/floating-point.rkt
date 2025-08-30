#lang typed/racket

(provide
 ;; XDR Floating Point
 xdr-floating-point xdr-floating-point? xdr-floating-point-number xdr-decode-floating-point xdr-encode-floating-point
 ;; XDR Double Precision Floating Point
 xdr-double-floating-point xdr-double-floating-point? xdr-double-floating-point-number xdr-decode-double xdr-encode-double
 ;; XDR Quadruple Precision Floating Point
 xdr-quadruple-floating-point xdr-quadruple-floating-point? xdr-quadruple-floating-point-number xdr-decode-quadruple xdr-encode-quadruple)

;; XDR Floating Point
;  The standard defines the floating-point data type "float" (32 bits or
;  4 bytes).  The encoding used is the IEEE standard for normalized
;  single-precision floating-point numbers [IEEE].  The following three
;  fields describe the single-precision floating-point number:
;
;     S: The sign of the number.  Values 0 and 1 represent positive and
;        negative, respectively.  One bit.

;     E: The exponent of the number, base 2.  8 bits are devoted to this
;        field.  The exponent is biased by 127.
;
;     F: The fractional part of the number's mantissa, base 2.  23 bits
;        are devoted to this field.
;
;  Therefore, the floating-point number is described by:
;
;        (-1)**S * 2**(E-Bias) * 1.F
;
;  It is declared as follows:
;
;        float identifier;
;
;        +-------+-------+-------+-------+
;        |byte 0 |byte 1 |byte 2 |byte 3 |              SINGLE-PRECISION
;        S|   E   |           F          |         FLOATING-POINT NUMBER
;        +-------+-------+-------+-------+
;        1|<- 8 ->|<-------23 bits------>|
;        <------------32 bits------------>
;
;  Just as the most and least significant bytes of a number are 0 and 3,
;  the most and least significant bits of a single-precision floating-
;  point number are 0 and 31.  The beginning bit (and most significant
;  bit) offsets of S, E, and F are 0, 1, and 9, respectively.  Note that
;  these numbers refer to the mathematical positions of the bits, and
;  NOT to their actual physical locations (which vary from medium to
;  medium).
;
;  The IEEE specifications should be consulted concerning the encoding
;  for signed zero, signed infinity (overflow), and denormalized numbers
;  (underflow) [IEEE].  According to IEEE specifications, the "NaN" (not
;  a number) is system dependent and should not be interpreted within
;  XDR as anything other than "NaN".
(struct xdr-floating-point ([number : Float]) #:transparent)

(: xdr-decode-floating-point (-> Bytes xdr-floating-point))
(define (xdr-decode-floating-point bstr)
  (unless (= (bytes-length bstr) 4)
    (error 'xdr-decode-floating-point "expected 4 bytes, got ~a" (bytes-length bstr)))
  (xdr-floating-point (floating-point-bytes->real bstr #t)))

(: xdr-encode-floating-point (-> xdr-floating-point Bytes))
(define (xdr-encode-floating-point xdr-floating-point)
  (real->floating-point-bytes (xdr-floating-point-number xdr-floating-point) 4 #t))

;; XDR Double Precision Floating Point
;  The standard defines the encoding for the double-precision floating-
;  point data type "double" (64 bits or 8 bytes).  The encoding used is
;  the IEEE standard for normalized double-precision floating-point
;  numbers [IEEE].  The standard encodes the following three fields,
;  which describe the double-precision floating-point number:
;
;     S: The sign of the number.  Values 0 and 1 represent positive and
;        negative, respectively.  One bit.
;
;     E: The exponent of the number, base 2.  11 bits are devoted to
;        this field.  The exponent is biased by 1023.
;
;     F: The fractional part of the number's mantissa, base 2.  52 bits
;        are devoted to this field.
;
;  Therefore, the floating-point number is described by:
;
;        (-1)**S * 2**(E-Bias) * 1.F
;
;  It is declared as follows:
;
;        double identifier;
;
;        +------+------+------+------+------+------+------+------+
;        |byte 0|byte 1|byte 2|byte 3|byte 4|byte 5|byte 6|byte 7|
;        S|    E   |                    F                        |
;        +------+------+------+------+------+------+------+------+
;        1|<--11-->|<-----------------52 bits------------------->|
;        <-----------------------64 bits------------------------->
;                               DOUBLE-PRECISION FLOATING-POINT
;
;  Just as the most and least significant bytes of a number are 0 and 7,
;  the most and least significant bits of a double-precision floating-
;  point number are 0 and 63.  The beginning bit (and most significant
;  bit) offsets of S, E, and F are 0, 1, and 12, respectively.  Note
;  that these numbers refer to the mathematical positions of the bits,
;  and NOT to their actual physical locations (which vary from medium to
;  medium).
;
;  The IEEE specifications should be consulted concerning the encoding
;  for signed zero, signed infinity (overflow), and denormalized numbers
;  (underflow) [IEEE].  According to IEEE specifications, the "NaN" (not
;  a number) is system dependent and should not be interpreted within
;  XDR as anything other than "NaN".
(struct xdr-double-floating-point ([number : Float]) #:transparent)

(: xdr-decode-double (-> Bytes xdr-double-floating-point))
(define (xdr-decode-double bstr)
  (unless (= (bytes-length bstr) 8)
    (error 'xdr-decode-double "expected 8 bytes, got ~a" (bytes-length bstr)))
  (xdr-double-floating-point (floating-point-bytes->real bstr #t)))

(: xdr-encode-double (-> xdr-double-floating-point Bytes))
(define (xdr-encode-double xdr-double-floating-point)
  (real->floating-point-bytes (xdr-double-floating-point-number xdr-double-floating-point) 8 #t))

;; XDR Quadruple Precision Floating Point
;  The standard defines the encoding for the quadruple-precision
;  floating-point data type "quadruple" (128 bits or 16 bytes).  The
;  encoding used is designed to be a simple analog of the encoding used
;  for single- and double-precision floating-point numbers using one
;  form of IEEE double extended precision.  The standard encodes the
;  following three fields, which describe the quadruple-precision
;  floating-point number:
;
;     S: The sign of the number.  Values 0 and 1 represent positive and
;        negative, respectively.  One bit.
;
;     E: The exponent of the number, base 2.  15 bits are devoted to
;        this field.  The exponent is biased by 16383.
;
;     F: The fractional part of the number's mantissa, base 2.  112 bits
;        are devoted to this field.
;
;  Therefore, the floating-point number is described by:
;
;        (-1)**S * 2**(E-Bias) * 1.F
;
;  It is declared as follows:
;
;        quadruple identifier;
;
;        +------+------+------+------+------+------+-...--+------+
;        |byte 0|byte 1|byte 2|byte 3|byte 4|byte 5| ...  |byte15|
;        S|    E       |                  F                      |
;        +------+------+------+------+------+------+-...--+------+
;        1|<----15---->|<-------------112 bits------------------>|
;        <-----------------------128 bits------------------------>
;                               QUADRUPLE-PRECISION FLOATING-POINT
;
;  Just as the most and least significant bytes of a number are 0 and 15,
;  the most and least significant bits of a quadruple-precision
;  floating-point number are 0 and 127.  The beginning bit (and most
;  significant bit) offsets of S, E, and F are 0, 1, and 16,
;  respectively.  Note that these numbers refer to the mathematical
;  positions of the bits, and NOT to their actual physical locations
;  (which vary from medium to medium).
;
;  The encoding for signed zero, signed infinity (overflow), and
;  denormalized numbers are analogs of the corresponding encodings for
;  single and double-precision floating-point numbers.  The "NaN"
;  encoding as it applies to quadruple-precision floating-point numbers
;  is system dependent and should not be interpreted within XDR as
;  anything other than "NaN".
(struct xdr-quadruple-floating-point ([number : Float]) #:transparent)

(: xdr-decode-quadruple (-> Bytes xdr-quadruple-floating-point))
(define (xdr-decode-quadruple bstr)
  (error 'xdr-decode-quadruple "quadruple-precision floating-point is not supported"))

(: xdr-encode-quadruple (-> xdr-quadruple-floating-point Bytes))
(define (xdr-encode-quadruple xdr-quadruple-floating-point)
  (error 'xdr-encode-quadruple "quadruple-precision floating-point is not supported"))
