#lang racket

(require rackunit
         rackunit/text-ui)
(require "../xdr/array.rkt"
         "../xdr/integer.rkt"
         "../xdr/boolean.rkt"
         "../xdr/hyper.rkt"
         "../xdr/floating-point.rkt"
         "../xdr/string.rkt"
         "../xdr/opaque.rkt"
         "../xdr/void.rkt")

;; Constants as XDR Fixed-Length Array
(define EMPTY_XDR_FIXED_LENGTH_ARRAY (xdr-fixed-length-array 0 '() xdr-encode-int xdr-decode-int))
(define TWO_ELEMENT_INT_ARRAY (xdr-fixed-length-array 2 (list (xdr-int 1) (xdr-int 2)) xdr-encode-int xdr-decode-int))
(define TWO_ELEMENT_UNSIGNED_INT_ARRAY (xdr-fixed-length-array 2 (list (xdr-uint 1) (xdr-uint 2)) xdr-encode-uint xdr-decode-uint))

;; Boolean arrays
(define TWO_ELEMENT_BOOLEAN_ARRAY (xdr-fixed-length-array 2 (list (xdr-boolean #t) (xdr-boolean #f)) xdr-encode-boolean xdr-decode-boolean))

;; Hyper arrays
(define TWO_ELEMENT_HYPER_ARRAY (xdr-fixed-length-array 2 (list (xdr-hyper 1000000000000) (xdr-hyper -1000000000000)) xdr-encode-hyper xdr-decode-hyper))
(define TWO_ELEMENT_UHYPER_ARRAY (xdr-fixed-length-array 2 (list (xdr-uhyper 1000000000000) (xdr-uhyper 2000000000000)) xdr-encode-uhyper xdr-decode-uhyper))

;; Floating-point arrays
(define TWO_ELEMENT_FLOAT_ARRAY (xdr-fixed-length-array 2 (list (xdr-floating-point 3.14) (xdr-floating-point -2.71)) xdr-encode-floating-point xdr-decode-floating-point))
(define TWO_ELEMENT_DOUBLE_ARRAY (xdr-fixed-length-array 2 (list (xdr-double-floating-point 3.141592653589793) (xdr-double-floating-point -2.718281828459045)) xdr-encode-double xdr-decode-double))

;; String arrays
(define TWO_ELEMENT_STRING_ARRAY (xdr-fixed-length-array 2 (list (xdr-string "hello") (xdr-string "world")) xdr-encode-string xdr-decode-string))

;; Variable-length opaque data arrays
(define TWO_ELEMENT_OPAQUE_ARRAY (xdr-fixed-length-array 2 (list (xdr-opaque #"test") (xdr-opaque #"data")) xdr-encode-opaque xdr-decode-opaque))

;; Void arrays
(define TWO_ELEMENT_VOID_ARRAY (xdr-fixed-length-array 2 (list (xdr-void) (xdr-void)) xdr-encode-void xdr-decode-void))

;; Variable-Length Array Constants
(define EMPTY_XDR_VARIABLE_LENGTH_ARRAY (xdr-variable-length-array '() xdr-encode-int xdr-decode-int #f))
(define TWO_ELEMENT_VARIABLE_INT_ARRAY (xdr-variable-length-array (list (xdr-int 1) (xdr-int 2)) xdr-encode-int xdr-decode-int #f))
(define TWO_ELEMENT_VARIABLE_UINT_ARRAY (xdr-variable-length-array (list (xdr-uint 1) (xdr-uint 2)) xdr-encode-uint xdr-decode-uint #f))
(define TWO_ELEMENT_VARIABLE_BOOLEAN_ARRAY (xdr-variable-length-array (list (xdr-boolean #t) (xdr-boolean #f)) xdr-encode-boolean xdr-decode-boolean #f))
(define TWO_ELEMENT_VARIABLE_HYPER_ARRAY (xdr-variable-length-array (list (xdr-hyper 1000000000000) (xdr-hyper -1000000000000)) xdr-encode-hyper xdr-decode-hyper #f))
(define TWO_ELEMENT_VARIABLE_UHYPER_ARRAY (xdr-variable-length-array (list (xdr-uhyper 1000000000000) (xdr-uhyper 2000000000000)) xdr-encode-uhyper xdr-decode-uhyper #f))
(define TWO_ELEMENT_VARIABLE_FLOAT_ARRAY (xdr-variable-length-array (list (xdr-floating-point 3.14) (xdr-floating-point -2.71)) xdr-encode-floating-point xdr-decode-floating-point #f))
(define TWO_ELEMENT_VARIABLE_DOUBLE_ARRAY (xdr-variable-length-array (list (xdr-double-floating-point 3.141592653589793) (xdr-double-floating-point -2.718281828459045)) xdr-encode-double xdr-decode-double #f))
(define TWO_ELEMENT_VARIABLE_STRING_ARRAY (xdr-variable-length-array (list (xdr-string "hello") (xdr-string "world")) xdr-encode-string xdr-decode-string #f))
(define TWO_ELEMENT_VARIABLE_OPAQUE_ARRAY (xdr-variable-length-array (list (xdr-opaque #"test") (xdr-opaque #"data")) xdr-encode-opaque xdr-decode-opaque #f))
(define TWO_ELEMENT_VARIABLE_VOID_ARRAY (xdr-variable-length-array (list (xdr-void) (xdr-void)) xdr-encode-void xdr-decode-void #f))

;; Variable-length arrays with max-elements constraint
(define MAX_TWO_VARIABLE_INT_ARRAY (xdr-variable-length-array (list (xdr-int 1) (xdr-int 2)) xdr-encode-int xdr-decode-int 2))
(define EXCEEDS_MAX_VARIABLE_INT_ARRAY (xdr-variable-length-array (list (xdr-int 1) (xdr-int 2) (xdr-int 3)) xdr-encode-int xdr-decode-int 2))

;; Constants as Bytes
(define EMPTY_BYTES #"")
(define TWO_ELEMENT_INT_ARRAY_BYTES #"\x00\x00\x00\x01\x00\x00\x00\x02")
(define TWO_ELEMENT_UNSIGNED_INT_ARRAY_BYTES #"\x00\x00\x00\x01\x00\x00\x00\x02")

;; Boolean array bytes (true=1, false=0)
(define TWO_ELEMENT_BOOLEAN_ARRAY_BYTES #"\0\0\0\1\0\0\0\0")

;; Hyper array bytes (8 bytes each)
(define TWO_ELEMENT_HYPER_ARRAY_BYTES #"\0\0\0\350\324\245\20\0\377\377\377\27+Z\360\0")
(define TWO_ELEMENT_UHYPER_ARRAY_BYTES #"\0\0\0\350\324\245\20\0\0\0\1\321\251J \0")

;; Floating-point array bytes (4 bytes each for float, 8 bytes each for double)
(define TWO_ELEMENT_FLOAT_ARRAY_BYTES #"@H\365\303\300-p\244")
(define TWO_ELEMENT_DOUBLE_ARRAY_BYTES #"@\t!\373TD-\30\300\5\277\n\213\24Wi")

;; String array bytes (length-prefixed with padding)
(define TWO_ELEMENT_STRING_ARRAY_BYTES #"\0\0\0\5hello\0\0\0\0\0\0\5world\0\0\0")

;; Variable-length opaque data array bytes (length-prefixed with padding)
(define TWO_ELEMENT_OPAQUE_ARRAY_BYTES #"\0\0\0\4test\0\0\0\4data")

;; Void array bytes (empty for each void)
(define TWO_ELEMENT_VOID_ARRAY_BYTES #"")

;; Variable-Length Array Expected Bytes (count + elements)
(define EMPTY_VARIABLE_ARRAY_BYTES #"\0\0\0\0")  ; count=0
(define TWO_ELEMENT_VARIABLE_INT_ARRAY_BYTES #"\0\0\0\2\0\0\0\1\0\0\0\2")  ; count=2 + int(1) + int(2)
(define TWO_ELEMENT_VARIABLE_UINT_ARRAY_BYTES #"\0\0\0\2\0\0\0\1\0\0\0\2")  ; count=2 + uint(1) + uint(2)
(define TWO_ELEMENT_VARIABLE_BOOLEAN_ARRAY_BYTES #"\0\0\0\2\0\0\0\1\0\0\0\0")  ; count=2 + bool(true) + bool(false)
(define TWO_ELEMENT_VARIABLE_HYPER_ARRAY_BYTES #"\0\0\0\2\0\0\0\350\324\245\20\0\377\377\377\27+Z\360\0")  ; count=2 + hyper values
(define TWO_ELEMENT_VARIABLE_UHYPER_ARRAY_BYTES #"\0\0\0\2\0\0\0\350\324\245\20\0\0\0\1\321\251J \0")  ; count=2 + uhyper values
(define TWO_ELEMENT_VARIABLE_FLOAT_ARRAY_BYTES #"\0\0\0\2@H\365\303\300-p\244")  ; count=2 + float values
(define TWO_ELEMENT_VARIABLE_DOUBLE_ARRAY_BYTES #"\0\0\0\2@\t!\373TD-\30\300\5\277\n\213\24Wi")  ; count=2 + double values
(define TWO_ELEMENT_VARIABLE_STRING_ARRAY_BYTES #"\0\0\0\2\0\0\0\5hello\0\0\0\0\0\0\5world\0\0\0")  ; count=2 + string values
(define TWO_ELEMENT_VARIABLE_OPAQUE_ARRAY_BYTES #"\0\0\0\2\0\0\0\4test\0\0\0\4data")  ; count=2 + opaque values
(define TWO_ELEMENT_VARIABLE_VOID_ARRAY_BYTES #"\0\0\0\2")  ; count=2 + void values (empty)

(define array-tests
  (test-suite
   "XDR Array Tests"
   (test-suite "Array Encoding Tests"
               (test-case "Empty List<xdr-int>"
                          (check-equal? EMPTY_BYTES (xdr-encode-fixed-length-array EMPTY_XDR_FIXED_LENGTH_ARRAY)))
               (test-case "List<xdr-int>"
                          (check-equal? TWO_ELEMENT_INT_ARRAY_BYTES (xdr-encode-fixed-length-array TWO_ELEMENT_INT_ARRAY)))
               (test-case "List<xdr-uint>"
                          (check-equal? TWO_ELEMENT_UNSIGNED_INT_ARRAY_BYTES (xdr-encode-fixed-length-array TWO_ELEMENT_UNSIGNED_INT_ARRAY)))
               (test-case "List<xdr-boolean>"
                          (check-equal? TWO_ELEMENT_BOOLEAN_ARRAY_BYTES (xdr-encode-fixed-length-array TWO_ELEMENT_BOOLEAN_ARRAY)))
               (test-case "List<xdr-hyper>"
                          (check-equal? TWO_ELEMENT_HYPER_ARRAY_BYTES (xdr-encode-fixed-length-array TWO_ELEMENT_HYPER_ARRAY)))
               (test-case "List<xdr-uhyper>"
                          (check-equal? TWO_ELEMENT_UHYPER_ARRAY_BYTES (xdr-encode-fixed-length-array TWO_ELEMENT_UHYPER_ARRAY)))
               (test-case "List<xdr-floating-point>"
                          (check-equal? TWO_ELEMENT_FLOAT_ARRAY_BYTES (xdr-encode-fixed-length-array TWO_ELEMENT_FLOAT_ARRAY)))
               (test-case "List<xdr-double-floating-point>"
                          (check-equal? TWO_ELEMENT_DOUBLE_ARRAY_BYTES (xdr-encode-fixed-length-array TWO_ELEMENT_DOUBLE_ARRAY)))
               (test-case "List<xdr-string>"
                          (check-equal? TWO_ELEMENT_STRING_ARRAY_BYTES (xdr-encode-fixed-length-array TWO_ELEMENT_STRING_ARRAY)))
               (test-case "List<xdr-variable-length-opaque-data>"
                          (check-equal? TWO_ELEMENT_OPAQUE_ARRAY_BYTES (xdr-encode-fixed-length-array TWO_ELEMENT_OPAQUE_ARRAY)))
               (test-case "List<xdr-void>"
                          (check-equal? TWO_ELEMENT_VOID_ARRAY_BYTES (xdr-encode-fixed-length-array TWO_ELEMENT_VOID_ARRAY))))
   (test-suite "Variable-Length Array Encoding Tests"
               (test-case "Empty Variable Array<xdr-int>"
                          (check-equal? EMPTY_VARIABLE_ARRAY_BYTES (xdr-encode-variable-length-array EMPTY_XDR_VARIABLE_LENGTH_ARRAY)))
               (test-case "Variable Array<xdr-int>"
                          (check-equal? TWO_ELEMENT_VARIABLE_INT_ARRAY_BYTES (xdr-encode-variable-length-array TWO_ELEMENT_VARIABLE_INT_ARRAY)))
               (test-case "Variable Array<xdr-uint>"
                          (check-equal? TWO_ELEMENT_VARIABLE_UINT_ARRAY_BYTES (xdr-encode-variable-length-array TWO_ELEMENT_VARIABLE_UINT_ARRAY)))
               (test-case "Variable Array<xdr-boolean>"
                          (check-equal? TWO_ELEMENT_VARIABLE_BOOLEAN_ARRAY_BYTES (xdr-encode-variable-length-array TWO_ELEMENT_VARIABLE_BOOLEAN_ARRAY)))
               (test-case "Variable Array<xdr-hyper>"
                          (check-equal? TWO_ELEMENT_VARIABLE_HYPER_ARRAY_BYTES (xdr-encode-variable-length-array TWO_ELEMENT_VARIABLE_HYPER_ARRAY)))
               (test-case "Variable Array<xdr-uhyper>"
                          (check-equal? TWO_ELEMENT_VARIABLE_UHYPER_ARRAY_BYTES (xdr-encode-variable-length-array TWO_ELEMENT_VARIABLE_UHYPER_ARRAY)))
               (test-case "Variable Array<xdr-floating-point>"
                          (check-equal? TWO_ELEMENT_VARIABLE_FLOAT_ARRAY_BYTES (xdr-encode-variable-length-array TWO_ELEMENT_VARIABLE_FLOAT_ARRAY)))
               (test-case "Variable Array<xdr-double-floating-point>"
                          (check-equal? TWO_ELEMENT_VARIABLE_DOUBLE_ARRAY_BYTES (xdr-encode-variable-length-array TWO_ELEMENT_VARIABLE_DOUBLE_ARRAY)))
               (test-case "Variable Array<xdr-string>"
                          (check-equal? TWO_ELEMENT_VARIABLE_STRING_ARRAY_BYTES (xdr-encode-variable-length-array TWO_ELEMENT_VARIABLE_STRING_ARRAY)))
               (test-case "Variable Array<xdr-opaque>"
                          (check-equal? TWO_ELEMENT_VARIABLE_OPAQUE_ARRAY_BYTES (xdr-encode-variable-length-array TWO_ELEMENT_VARIABLE_OPAQUE_ARRAY)))
               (test-case "Variable Array<xdr-void>"
                          (check-equal? TWO_ELEMENT_VARIABLE_VOID_ARRAY_BYTES (xdr-encode-variable-length-array TWO_ELEMENT_VARIABLE_VOID_ARRAY)))
               (test-case "Variable Array with max-elements constraint"
                          (check-equal? TWO_ELEMENT_VARIABLE_INT_ARRAY_BYTES (xdr-encode-variable-length-array MAX_TWO_VARIABLE_INT_ARRAY)))
               (test-case "Variable Array exceeding max-elements constraint"
                          (check-exn exn:fail? (lambda () (xdr-encode-variable-length-array EXCEEDS_MAX_VARIABLE_INT_ARRAY)))))
   (test-suite "Array Decoding Tests"
               (test-case "Empty List<xdr-int>"
                          (check-exn exn:fail? (lambda () (xdr-decode-fixed-length-array EMPTY_BYTES))))
               (test-case "List<xdr-int>"
                          (check-exn exn:fail? (lambda () (xdr-decode-fixed-length-array TWO_ELEMENT_INT_ARRAY_BYTES))))
               (test-case "List<xdr-uint>"
                          (check-exn exn:fail? (lambda () (xdr-decode-fixed-length-array TWO_ELEMENT_UNSIGNED_INT_ARRAY_BYTES))))
               (test-case "List<xdr-boolean>"
                          (check-exn exn:fail? (lambda () (xdr-decode-fixed-length-array TWO_ELEMENT_BOOLEAN_ARRAY_BYTES))))
               (test-case "List<xdr-hyper>"
                          (check-exn exn:fail? (lambda () (xdr-decode-fixed-length-array TWO_ELEMENT_HYPER_ARRAY_BYTES))))
               (test-case "List<xdr-uhyper>"
                          (check-exn exn:fail? (lambda () (xdr-decode-fixed-length-array TWO_ELEMENT_UHYPER_ARRAY_BYTES))))
               (test-case "List<xdr-floating-point>"
                          (check-exn exn:fail? (lambda () (xdr-decode-fixed-length-array TWO_ELEMENT_FLOAT_ARRAY_BYTES))))
               (test-case "List<xdr-double-floating-point>"
                          (check-exn exn:fail? (lambda () (xdr-decode-fixed-length-array TWO_ELEMENT_DOUBLE_ARRAY_BYTES))))
               (test-case "List<xdr-string>"
                          (check-exn exn:fail? (lambda () (xdr-decode-fixed-length-array TWO_ELEMENT_STRING_ARRAY_BYTES))))
               (test-case "List<xdr-variable-length-opaque-data>"
                          (check-exn exn:fail? (lambda () (xdr-decode-fixed-length-array TWO_ELEMENT_OPAQUE_ARRAY_BYTES))))
               (test-case "List<xdr-void>"
                          (check-exn exn:fail? (lambda () (xdr-decode-fixed-length-array TWO_ELEMENT_VOID_ARRAY_BYTES)))))
   (test-suite "Variable-Length Array Decoding Tests"
               (test-case "Empty Variable Array<xdr-int>"
                          (check-exn exn:fail? (lambda () (xdr-decode-variable-length-array EMPTY_VARIABLE_ARRAY_BYTES))))
               (test-case "Variable Array<xdr-int>"
                          (check-exn exn:fail? (lambda () (xdr-decode-variable-length-array TWO_ELEMENT_VARIABLE_INT_ARRAY_BYTES))))
               (test-case "Variable Array<xdr-uint>"
                          (check-exn exn:fail? (lambda () (xdr-decode-variable-length-array TWO_ELEMENT_VARIABLE_UINT_ARRAY_BYTES))))
               (test-case "Variable Array<xdr-boolean>"
                          (check-exn exn:fail? (lambda () (xdr-decode-variable-length-array TWO_ELEMENT_VARIABLE_BOOLEAN_ARRAY_BYTES))))
               (test-case "Variable Array<xdr-hyper>"
                          (check-exn exn:fail? (lambda () (xdr-decode-variable-length-array TWO_ELEMENT_VARIABLE_HYPER_ARRAY_BYTES))))
               (test-case "Variable Array<xdr-uhyper>"
                          (check-exn exn:fail? (lambda () (xdr-decode-variable-length-array TWO_ELEMENT_VARIABLE_UHYPER_ARRAY_BYTES))))
               (test-case "Variable Array<xdr-floating-point>"
                          (check-exn exn:fail? (lambda () (xdr-decode-variable-length-array TWO_ELEMENT_VARIABLE_FLOAT_ARRAY_BYTES))))
               (test-case "Variable Array<xdr-double-floating-point>"
                          (check-exn exn:fail? (lambda () (xdr-decode-variable-length-array TWO_ELEMENT_VARIABLE_DOUBLE_ARRAY_BYTES))))
               (test-case "Variable Array<xdr-string>"
                          (check-exn exn:fail? (lambda () (xdr-decode-variable-length-array TWO_ELEMENT_VARIABLE_STRING_ARRAY_BYTES))))
               (test-case "Variable Array<xdr-opaque>"
                          (check-exn exn:fail? (lambda () (xdr-decode-variable-length-array TWO_ELEMENT_VARIABLE_OPAQUE_ARRAY_BYTES))))
               (test-case "Variable Array<xdr-void>"
                          (check-exn exn:fail? (lambda () (xdr-decode-variable-length-array TWO_ELEMENT_VARIABLE_VOID_ARRAY_BYTES)))))))

(run-tests array-tests)
