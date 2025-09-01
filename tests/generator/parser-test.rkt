#lang racket

(require rackunit
         rackunit/text-ui)
(require "../../xdr/generator/parser.rkt")

;; Constants - Constant
(define MAX_SIZE_CONSTANT "const MAX_SIZE = 42")
(define MAX_SIZE_PARSED_EXPECTED '(TOP_CONFIG (CONST_EXPR "const" "MAX_SIZE" "=" (ANY_VALUE 42))))

;; Constants - Enum
(define COLOR_ENUM_CONSTANT "enum COLOR { RED = 1, GREEN = 2, BLUE = 3 }")
(define COLOR_ENUM_CONSTANT_PARSED_EXPECTED
  '(TOP_CONFIG (ENUM_EXPR "enum" "COLOR" "{"
                          (ENUM_MEMBER "RED" "=" (ANY_VALUE 1)) COMMA
                          (ENUM_MEMBER "GREEN" "=" (ANY_VALUE 2)) COMMA
                          (ENUM_MEMBER "BLUE" "=" (ANY_VALUE 3))
                          "}")))

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
    (STRUCT_EXPR
     "struct"
     "Dog"
     "{"
     (STRUCT_MEMBER_LINE NEWLINE (STRUCT_MEMBER "NAME_1" "SomeType" SEMICOLON))
     (STRUCT_MEMBER_LINE NEWLINE (STRUCT_MEMBER "NAME_2" "int" SEMICOLON))
     (STRUCT_MEMBER_LINE NEWLINE (STRUCT_MEMBER "NAME_3" "string" SEMICOLON))
     NEWLINE
     "}")))

(define parser-tests
  (test-suite
   "XDR Parser Tests"
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
                           COLOR_ENUM_CONSTANT_PARSED_EXPECTED)))
   (test-suite "Struct Expression Parsing Tests"
               (test-case "Struct Expression Parsing - Parse Success"
                          (check-not-false (parse-expr COLOR_STRUCT_CONSTANT)))
               (test-case "Struct Expression Parsing - Parse Tree"
                          (check-equal?
                           (syntax->datum (parse-expr COLOR_STRUCT_CONSTANT))
                           COLOR_STRUCT_CONSTANT_PARSED_EXPECTED)))))

(run-tests parser-tests)