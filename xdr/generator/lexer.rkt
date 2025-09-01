#lang racket

(require br-parser-tools/lex
         brag/support)

;; Token types
(define-empty-tokens empty-toks (COMMA SEMICOLON NEWLINE))
(define-tokens       value-toks (NUMBER IDENTIFIER STRING))

;; Create the basic lexer
(define basic-lex
  (lexer
   [(:+ (:or #\space #\tab)) (basic-lex input-port)]
   [(:+ #\newline) (token-NEWLINE)]
   ["const"    "const"]
   ["enum"     "enum"]
   ["struct"   "struct"]
   ["%#include" "%#include"]
   ["="        "="]
   ["{"        "{"]
   ["}"        "}"]
   [","        (token-COMMA)]
   [";"        (token-SEMICOLON)]
   [(:seq #\" (:* (:~ #\")) #\") (token-STRING (substring lexeme 1 (- (string-length lexeme) 1)))]
   [(:+ numeric) (token-NUMBER (string->number lexeme))]
   [(:seq (:or alphabetic "_") (:* (:or alphabetic numeric "_"))) (token-IDENTIFIER lexeme)]
   [(eof)      (void)]))

;; Create a lexer function that works with brag
(define (make-lexer input-port)
  (lambda ()
    (basic-lex input-port)))

;; For compatibility with the parser
(define lex make-lexer)

(provide lex)
