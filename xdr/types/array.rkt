#lang typed/racket

(provide xdr-fixed-length-array xdr-encode-fixed-length-array xdr-decode-fixed-length-array
         xdr-variable-length-array xdr-encode-variable-length-array xdr-decode-variable-length-array)

(require "../internal/common.rkt")

;; Fixed-Length Array
;  Declarations for fixed-length arrays of homogeneous elements are in
;  the following form:

;        type-name identifier[n];

;  Fixed-length arrays of elements numbered 0 through n-1 are encoded by
;  individually encoding the elements of the array in their natural
;  order, 0 through n-1.  Each element's size is a multiple of four
;  bytes.  Though all elements are of the same type, the elements may
;  have different sizes.  For example, in a fixed-length array of
;  strings, all elements are of type "string", yet each element will
;  vary in its length.

;        +---+---+---+---+---+---+---+---+...+---+---+---+---+
;        |   element 0   |   element 1   |...|  element n-1  |
;        +---+---+---+---+---+---+---+---+...+---+---+---+---+
;        |<--------------------n elements------------------->|
(struct (A) xdr-fixed-length-array
  ([num-elements : Integer]
   [elements     : (Listof A)]
   [encoder      : (-> A Bytes)]
   [decoder      : (-> Bytes A)]) #:transparent)

(: xdr-encode-fixed-length-array (All (A) (-> (xdr-fixed-length-array A) Bytes)))
(define (xdr-encode-fixed-length-array array)
  (list-encode (xdr-fixed-length-array-elements array)
               (xdr-fixed-length-array-encoder array)))

(: xdr-decode-fixed-length-array (All (A) (-> Bytes (xdr-fixed-length-array A))))
(define (xdr-decode-fixed-length-array bytes)
  (error "Not implemented"))

;; Variable-Length Array
;  Counted arrays provide the ability to encode variable-length arrays
;  of homogeneous elements.  The array is encoded as the element count n
;  (an unsigned integer) followed by the encoding of each of the array's
;  elements, starting with element 0 and progressing through element
;  n-1.  The declaration for variable-length arrays follows this form:
;
;        type-name identifier<m>;
;     or
;        type-name identifier<>;
;
;  The constant m specifies the maximum acceptable element count of an
;  array; if m is not specified, as in the second declaration, it is
;  assumed to be (2**32) - 1.
;
;          0  1  2  3
;        +--+--+--+--+--+--+--+--+--+--+--+--+...+--+--+--+--+
;        |     n     | element 0 | element 1 |...|element n-1|
;        +--+--+--+--+--+--+--+--+--+--+--+--+...+--+--+--+--+
;        |<-4 bytes->|<--------------n elements------------->|
;                                                        COUNTED ARRAY
(struct (A) xdr-variable-length-array
  ([elements     : (Listof A)]
   [encoder      : (-> A Bytes)]
   [decoder      : (-> Bytes A)]
   [max-elements : (Option Integer)]) #:transparent)

(: xdr-encode-variable-length-array (All (A) (-> (xdr-variable-length-array A) Bytes)))
(define (xdr-encode-variable-length-array array)
  (define elements (xdr-variable-length-array-elements array))
  (define count (length elements))
  (define max-count (xdr-variable-length-array-max-elements array))
  (when (and max-count (> count max-count))
    (error "Array has ~a elements, but maximum is ~a" count max-count))
  (define count-bytes (integer->integer-bytes count 4 #f #t))
  (define elements-bytes (list-encode elements (xdr-variable-length-array-encoder array)))
  (bytes-append count-bytes elements-bytes))

(: xdr-decode-variable-length-array (All (A) (-> Bytes (xdr-variable-length-array A))))
(define (xdr-decode-variable-length-array bytes)
  (error "Not implemented"))
