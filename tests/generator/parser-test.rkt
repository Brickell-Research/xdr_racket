#lang racket

(require rackunit
         rackunit/text-ui)
(require "../../xdr/generator/parser.rkt")

;; Constants - Namespace
(define NAMESPACE_WITH_EMPTY_BODY "namespace FOOBAR {}")
(define NAMESPACE_WITH_EMPTY_BODY_PARSED_EXPECTED '(TOP_CONFIG (NAMESPACE_EXPR "namespace" "FOOBAR" "{" "}")))
(define NAME_SPACE_WITH_CONSTANT "namespace FOOBAR { const MAX_SIZE = 42 }")
(define NAME_SPACE_WITH_CONSTANT_PARSED_EXPECTED '(TOP_CONFIG (NAMESPACE_EXPR "namespace" "FOOBAR" "{" (CONFIG (CONST_EXPR "const" "MAX_SIZE" "=" (ANY_VALUE 42))) "}")))

;; Constants - Constant
(define MAX_SIZE_CONSTANT "const MAX_SIZE = 42")
(define MAX_SIZE_PARSED_EXPECTED '(TOP_CONFIG (CONFIG (CONST_EXPR "const" "MAX_SIZE" "=" (ANY_VALUE 42)))))

;; Constants - Enum
(define COLOR_ENUM_CONSTANT "enum COLOR { RED = 1, GREEN = 2, BLUE = 3 }")
(define COLOR_ENUM_CONSTANT_PARSED_EXPECTED
  '(TOP_CONFIG (CONFIG (ENUM_EXPR "enum" "COLOR" "{"
                                  (ENUM_MEMBER "RED" "=" (ANY_VALUE 1)) COMMA
                                  (ENUM_MEMBER "GREEN" "=" (ANY_VALUE 2)) COMMA
                                  (ENUM_MEMBER "BLUE" "=" (ANY_VALUE 3))
                                  "}"))))
(define EMPTY_ENUM_CONSTANT "enum EMPTY_ENUM {}")
(define EMPTY_ENUM_CONSTANT_PARSED_EXPECTED '(TOP_CONFIG (CONFIG (ENUM_EXPR "enum" "EMPTY_ENUM" "{" "}"))))

;; Constants - Struct
(define COLOR_STRUCT_CONSTANT #<<EOF
struct Dog {
  NAME_1 SomeType;
  NAME_2 int;
  NAME_3 string;
}
EOF
  )
(define COLOR_STRUCT_CONSTANT_PARSED_EXPECTED
  '(TOP_CONFIG
    (CONFIG (STRUCT_EXPR
             "struct"
             "Dog"
             "{"
             (STRUCT_MEMBER_LINE NEWLINE (STRUCT_MEMBER "NAME_1" "SomeType" SEMICOLON))
             (STRUCT_MEMBER_LINE NEWLINE (STRUCT_MEMBER "NAME_2" "int" SEMICOLON))
             (STRUCT_MEMBER_LINE NEWLINE (STRUCT_MEMBER "NAME_3" "string" SEMICOLON))
             NEWLINE
             "}"))))
(define EMPTY_STRUCT_CONSTANT "struct EMPTY_STRUCT {}")
(define EMPTY_STRUCT_CONSTANT_PARSED_EXPECTED '(TOP_CONFIG (CONFIG (STRUCT_EXPR "struct" "EMPTY_STRUCT" "{" "}"))))

;; Constants - Include
;; %#include "xdr/Stellar-types.h"
(define INCLUDE_CONSTANT "%#include \"xdr/Stellar-types.h\"")
(define INCLUDE_CONSTANT_PARSED_EXPECTED '(TOP_CONFIG (CONFIG (INCLUDE_EXPR "%#include" (FILE_PATH "xdr/Stellar-types.h")))))


;; Constants - Typedef
;; typedef opaque UpgradeType<128>;
;; typedef TransactionEnvelope DependentTxCluster<>;
;; typedef unsigned hyper uint64;
;; typedef TransactionEnvelope DependentTxCluster<SOME_MAX_SIZE>;
;; typedef uint64 Duration;
;; typedef opaque Hash[32];
(define TYPEDEF_CONSTANT "typedef opaque UpgradeType<128>;")
(define TYPEDEF_CONSTANT_PARSED_EXPECTED '(TOP_CONFIG (CONFIG (TYPEDEF_EXPR "typedef" "opaque" "UpgradeType" "<" (ANY_VALUE 128) ">" SEMICOLON))))
(define TYPEDEF_CONSTANT_2 "typedef TransactionEnvelope DependentTxCluster<>;")
(define TYPEDEF_CONSTANT_2_PARSED_EXPECTED '(TOP_CONFIG (CONFIG (TYPEDEF_EXPR "typedef" "TransactionEnvelope" "DependentTxCluster" "<" ">" SEMICOLON))))
(define TYPEDEF_CONSTANT_3 "typedef unsigned hyper uint64;")
(define TYPEDEF_CONSTANT_3_PARSED_EXPECTED '(TOP_CONFIG (CONFIG (TYPEDEF_EXPR "typedef" "unsigned" "hyper" "uint64" SEMICOLON))))
(define TYPEDEF_CONSTANT_4 "typedef TransactionEnvelope DependentTxCluster<SOME_MAX_SIZE>;")
(define TYPEDEF_CONSTANT_4_PARSED_EXPECTED '(TOP_CONFIG (CONFIG (TYPEDEF_EXPR "typedef" "TransactionEnvelope" "DependentTxCluster" "<" (ANY_VALUE "SOME_MAX_SIZE") ">" SEMICOLON))))
(define TYPEDEF_CONSTANT_5 "typedef uint64 Duration;")
(define TYPEDEF_CONSTANT_5_PARSED_EXPECTED '(TOP_CONFIG (CONFIG (TYPEDEF_EXPR "typedef" "uint64" "Duration" SEMICOLON))))
(define TYPEDEF_CONSTANT_6 "typedef opaque Hash[32];")
(define TYPEDEF_CONSTANT_6_PARSED_EXPECTED '(TOP_CONFIG (CONFIG (TYPEDEF_EXPR "typedef" "opaque" "Hash" "[" (ANY_VALUE 32) "]" SEMICOLON))))

(define parser-tests
  (test-suite
   "XDR Parser Tests"
   (test-suite "Namespace Expression Parsing Tests"
               (test-case "Namespace Expression Parsing - Parse Success"
                          (check-not-false (parse-expr NAMESPACE_WITH_EMPTY_BODY)))
               (test-case "Namespace Expression Parsing - Parse Tree"
                          (check-equal?
                           (syntax->datum (parse-expr NAMESPACE_WITH_EMPTY_BODY))
                           NAMESPACE_WITH_EMPTY_BODY_PARSED_EXPECTED))
               (test-case "Namespace Expression Parsing - Parse Success"
                          (check-not-false (parse-expr NAME_SPACE_WITH_CONSTANT)))
               (test-case "Namespace Expression Parsing - Parse Tree"
                          (check-equal?
                           (syntax->datum (parse-expr NAME_SPACE_WITH_CONSTANT))
                           NAME_SPACE_WITH_CONSTANT_PARSED_EXPECTED)))
   (test-suite "Constant Expression Parsing Tests"
               (test-case "Constant Expression Parsing - Parse Success"
                          (check-not-false (parse-expr MAX_SIZE_CONSTANT)))
               (test-case "Constant Expression Parsing - Parse Tree"
                          (check-equal?
                           (syntax->datum (parse-expr MAX_SIZE_CONSTANT))
                           MAX_SIZE_PARSED_EXPECTED)))
   (test-suite "Enum Expression Parsing Tests"
               (test-case "Enum Expression Parsing - Parse Success"
                          (check-not-false (parse-expr COLOR_ENUM_CONSTANT)))
               (test-case "Enum Expression Parsing - Parse Tree"
                          (check-equal?
                           (syntax->datum (parse-expr COLOR_ENUM_CONSTANT))
                           COLOR_ENUM_CONSTANT_PARSED_EXPECTED))
               (test-case "Enum Expression Parsing - Parse Success"
                          (check-not-false (parse-expr EMPTY_ENUM_CONSTANT)))
               (test-case "Enum Expression Parsing - Parse Tree"
                          (check-equal?
                           (syntax->datum (parse-expr EMPTY_ENUM_CONSTANT))
                           EMPTY_ENUM_CONSTANT_PARSED_EXPECTED)))
   (test-suite "Struct Expression Parsing Tests"
               (test-case "Struct Expression Parsing - Parse Success"
                          (check-not-false (parse-expr COLOR_STRUCT_CONSTANT)))
               (test-case "Struct Expression Parsing - Parse Tree"
                          (check-equal?
                           (syntax->datum (parse-expr COLOR_STRUCT_CONSTANT))
                           COLOR_STRUCT_CONSTANT_PARSED_EXPECTED))
               (test-case "Struct Expression Parsing - Parse Success"
                          (check-not-false (parse-expr EMPTY_STRUCT_CONSTANT)))
               (test-case "Struct Expression Parsing - Parse Tree"
                          (check-equal?
                           (syntax->datum (parse-expr EMPTY_STRUCT_CONSTANT))
                           EMPTY_STRUCT_CONSTANT_PARSED_EXPECTED)))
   (test-suite "Include Expression Parsing Tests"
               (test-case "Include Expression Parsing - Parse Success"
                          (check-not-false (parse-expr INCLUDE_CONSTANT)))
               (test-case "Include Expression Parsing - Parse Tree"
                          (check-equal?
                           (syntax->datum (parse-expr INCLUDE_CONSTANT))
                           INCLUDE_CONSTANT_PARSED_EXPECTED)))

   (test-suite "Typedef Expression Parsing Tests"
               (test-case "Typedef Expression Parsing - Parse Success"
                          (check-not-false (parse-expr TYPEDEF_CONSTANT)))
               (test-case "Typedef Expression Parsing - Parse Tree"
                          (check-equal?
                           (syntax->datum (parse-expr TYPEDEF_CONSTANT))
                           TYPEDEF_CONSTANT_PARSED_EXPECTED))
               (test-case "Typedef Expression Parsing - Parse Success"
                          (check-not-false (parse-expr TYPEDEF_CONSTANT_2)))
               (test-case "Typedef Expression Parsing - Parse Tree"
                          (check-equal?
                           (syntax->datum (parse-expr TYPEDEF_CONSTANT_2))
                           TYPEDEF_CONSTANT_2_PARSED_EXPECTED))
               (test-case "Typedef Expression Parsing - Parse Success"
                          (check-not-false (parse-expr TYPEDEF_CONSTANT_3)))
               (test-case "Typedef Expression Parsing - Parse Tree"
                          (check-equal?
                           (syntax->datum (parse-expr TYPEDEF_CONSTANT_3))
                           TYPEDEF_CONSTANT_3_PARSED_EXPECTED))
               (test-case "Typedef Expression Parsing - Parse Success"
                          (check-not-false (parse-expr TYPEDEF_CONSTANT_4)))
               (test-case "Typedef Expression Parsing - Parse Tree"
                          (check-equal?
                           (syntax->datum (parse-expr TYPEDEF_CONSTANT_4))
                           TYPEDEF_CONSTANT_4_PARSED_EXPECTED))
               (test-case "Typedef Expression Parsing - Parse Success"
                          (check-not-false (parse-expr TYPEDEF_CONSTANT_5)))
               (test-case "Typedef Expression Parsing - Parse Tree"
                          (check-equal?
                           (syntax->datum (parse-expr TYPEDEF_CONSTANT_5))
                           TYPEDEF_CONSTANT_5_PARSED_EXPECTED))
               (test-case "Typedef Expression Parsing - Parse Success"
                          (check-not-false (parse-expr TYPEDEF_CONSTANT_6)))
               (test-case "Typedef Expression Parsing - Parse Tree"
                          (check-equal?
                           (syntax->datum (parse-expr TYPEDEF_CONSTANT_6))
                           TYPEDEF_CONSTANT_6_PARSED_EXPECTED)))))
(run-tests parser-tests)