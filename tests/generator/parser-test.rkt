#lang br
(require xdr/generator/parser xdr/generator/tokenizer brag/support)

(require rackunit
         rackunit/text-ui)
(require "../../xdr/generator/parser.rkt")

;; Helper functions
(define (xdr-any-value-gen value)
  `(xdr-any-value ,value))
(define (xdr-int-gen value)
  (xdr-any-value-gen `(xdr-integer-value ,value)))
(define (xdr-decimal-gen value)
  (xdr-any-value-gen `(xdr-decimal-value ,value)))
(define (xdr-string-gen value)
  (xdr-any-value-gen `(xdr-string-value ,value)))

;; Namespace
(define NAMESPACE_WITH_EMPTY_BODY "namespace FOOBAR {}")
(define NAMESPACE_WITH_EMPTY_BODY_PARSED_EXPECTED '(program (xdr-namespace-expr "FOOBAR")))
(define NAMESPACE_WITH_CONSTANT "namespace FOOBAR { const FOO = 42 }")
(define NAMESPACE_WITH_CONSTANT_PARSED_EXPECTED `(program (xdr-namespace-expr "FOOBAR" (xdr-config (xdr-const-expr (xdr-const-name "FOO") ,(xdr-int-gen 42))))))

;; Constants
(define (define-const-tree name value)
  `(program (xdr-config (xdr-const-expr (xdr-const-name ,name) ,value))))
(define CONSTANT_WITH_INTEGER_VALUE "const FOO = 42")
(define CONSTANT_WITH_INTEGER_VALUE_PARSED_EXPECTED (define-const-tree "FOO" (xdr-int-gen 42)))
(define CONSTANT_WITH_DECIMAL_VALUE "const FOO = 123.45")
(define CONSTANT_WITH_DECIMAL_VALUE_PARSED_EXPECTED (define-const-tree "FOO" (xdr-decimal-gen 123.45)))
(define CONSTANT_WITH_STRING_VALUE "const FOO = \"Hello, World!\"")
(define CONSTANT_WITH_STRING_VALUE_PARSED_EXPECTED (define-const-tree "FOO" (xdr-string-gen "Hello, World!")))

;; Enums
(define EMPTY_ENUM_CONSTANT "enum EMPTY_ENUM {}")
(define EMPTY_ENUM_CONSTANT_PARSED_EXPECTED '(program (xdr-config (xdr-enum-expr "EMPTY_ENUM"))))
(define COLOR_ENUM_CONSTANT "enum COLOR { RED = 1, GREEN = 2, BLUE = 3 }")
(define (enum-member-gen name value)
  `(xdr-enum-member ,name ,value))
(define (enum-gen name members)
  `(program (xdr-config (xdr-enum-expr ,name ,@members))))
(define COLOR_ENUM_CONSTANT_PARSED_EXPECTED (enum-gen "COLOR" (list (enum-member-gen "RED" (xdr-int-gen 1)) (enum-member-gen "GREEN" (xdr-int-gen 2)) (enum-member-gen "BLUE" (xdr-int-gen 3)))))

;; Typedefs
(define (typedef-tree . args)
  `(program (xdr-config (xdr-typedef-expr ,@args))))
(define SIMPLE_TYPEDEF "typedef uint64 Duration;")
(define SIMPLE_TYPEDEF_PARSED_EXPECTED (typedef-tree "uint64" "Duration"))
(define TYPEDEF_WITH_SIZE "typedef opaque UpgradeType<128>;")
(define TYPEDEF_WITH_SIZE_PARSED_EXPECTED (typedef-tree "opaque" "UpgradeType" (xdr-int-gen 128)))
(define TYPEDEF_WITHOUT_SIZE "typedef TransactionEnvelope DependentTxCluster<>;")
(define TYPEDEF_WITHOUT_SIZE_PARSED_EXPECTED (typedef-tree "TransactionEnvelope" "DependentTxCluster"))
(define TYPEDEF_WITH_ARRAY "typedef opaque Hash[32];")
(define TYPEDEF_WITH_ARRAY_PARSED_EXPECTED (typedef-tree "opaque" "Hash" (xdr-int-gen 32)))
(define TYPEDEF_WITH_MULTIPLE_IDENTIFIERS "typedef unsigned hyper uint64;")
(define TYPEDEF_WITH_MULTIPLE_IDENTIFIERS_PARSED_EXPECTED (typedef-tree "unsigned" "hyper" "uint64"))

;; Includes
(define (include-tree file-path)
  `(program (xdr-config (xdr-include-expr ,file-path))))
(define STELLAR_TYPES_INCLUDE "%#include \"xdr/Stellar-types.h\";")
(define STELLAR_TYPES_INCLUDE_PARSED_EXPECTED (include-tree '(xdr-string-value "xdr/Stellar-types.h")))
(define SIMPLE_HEADER_INCLUDE "%#include \"types.h\";")
(define SIMPLE_HEADER_INCLUDE_PARSED_EXPECTED (include-tree '(xdr-string-value "types.h")))

(define (apply-parser input)
  (parse-to-datum (apply-tokenizer make-tokenizer input)))

(define (assert-parse input expected)
  (define actual (apply-parser input))
  (check-equal? actual expected))

;; Structs
(define (struct-member-gen type-name var-name)
  `(xdr-struct-member-line #f (xdr-struct-member ,type-name ,var-name)))
(define (struct-tree name members)
  `(program (xdr-config (xdr-struct-expr ,name ,@members))))

(define SIMPLE_STRUCT_CONSTANT "struct Dog {
  SomeType NAME_1;
  int NAME_2;
  string NAME_3;
}")
(define SIMPLE_STRUCT_CONSTANT_PARSED_EXPECTED
  (struct-tree "Dog" (list
                      (struct-member-gen "SomeType" "NAME_1")
                      (struct-member-gen "int" "NAME_2")
                      (struct-member-gen "string" "NAME_3")
                      '#f)))
(define EMPTY_STRUCT_CONSTANT "struct EMPTY_STRUCT {}")
(define EMPTY_STRUCT_CONSTANT_PARSED_EXPECTED '(program (xdr-config (xdr-struct-expr "EMPTY_STRUCT"))))

(define parser-tests
  (test-suite "parser tests"
              (test-suite "namespace"
                          (test-case "empty body"
                                     (assert-parse NAMESPACE_WITH_EMPTY_BODY NAMESPACE_WITH_EMPTY_BODY_PARSED_EXPECTED))
                          (test-case "with constant"
                                     (assert-parse NAMESPACE_WITH_CONSTANT NAMESPACE_WITH_CONSTANT_PARSED_EXPECTED)))
              (test-suite "constant"
                          (test-case "with integer value"
                                     (assert-parse CONSTANT_WITH_INTEGER_VALUE CONSTANT_WITH_INTEGER_VALUE_PARSED_EXPECTED))
                          (test-case "with decimal value"
                                     (assert-parse CONSTANT_WITH_DECIMAL_VALUE CONSTANT_WITH_DECIMAL_VALUE_PARSED_EXPECTED))
                          (test-case "with string value"
                                     (assert-parse CONSTANT_WITH_STRING_VALUE CONSTANT_WITH_STRING_VALUE_PARSED_EXPECTED)))
              (test-suite "enum"
                          (test-case "empty"
                                     (assert-parse EMPTY_ENUM_CONSTANT EMPTY_ENUM_CONSTANT_PARSED_EXPECTED))
                          (test-case "with members"
                                     (assert-parse COLOR_ENUM_CONSTANT COLOR_ENUM_CONSTANT_PARSED_EXPECTED)))
              (test-suite "struct"
                          (test-case "empty"
                                     (assert-parse EMPTY_STRUCT_CONSTANT EMPTY_STRUCT_CONSTANT_PARSED_EXPECTED))
                          (test-case "with members"
                                     (assert-parse SIMPLE_STRUCT_CONSTANT SIMPLE_STRUCT_CONSTANT_PARSED_EXPECTED)))
              (test-suite "typedef"
                          (test-case "simple"
                                     (assert-parse SIMPLE_TYPEDEF SIMPLE_TYPEDEF_PARSED_EXPECTED))
                          (test-case "with size"
                                     (assert-parse TYPEDEF_WITH_SIZE TYPEDEF_WITH_SIZE_PARSED_EXPECTED))
                          (test-case "without size"
                                     (assert-parse TYPEDEF_WITHOUT_SIZE TYPEDEF_WITHOUT_SIZE_PARSED_EXPECTED))
                          (test-case "with array"
                                     (assert-parse TYPEDEF_WITH_ARRAY TYPEDEF_WITH_ARRAY_PARSED_EXPECTED))
                          (test-case "with multiple identifiers"
                                     (assert-parse TYPEDEF_WITH_MULTIPLE_IDENTIFIERS TYPEDEF_WITH_MULTIPLE_IDENTIFIERS_PARSED_EXPECTED)))
              (test-suite "include"
                          (test-case "stellar types"
                                     (assert-parse STELLAR_TYPES_INCLUDE STELLAR_TYPES_INCLUDE_PARSED_EXPECTED))
                          (test-case "simple header"
                                     (assert-parse SIMPLE_HEADER_INCLUDE SIMPLE_HEADER_INCLUDE_PARSED_EXPECTED)))))

(run-tests parser-tests)
