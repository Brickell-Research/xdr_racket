#lang racket

(require br-parser-tools/lex
         brag/support)

(define-lex-abbrev digits (:+ (char-set "0123456789")))

;; Create the basic lexer
(define basic-lexer
  (lexer-srcloc
   [(from/to "//" "\n") (token 'COMMENT lexeme)]
   ["\n" (token 'LINE-SEP)]
   [whitespace (token lexeme #:skip? #t)]
   [(:or "const" "enum" "struct" "typedef" "namespace" "%#include") (token 'KEYWORD lexeme)]
   [(:or "=" "{" "}" "<" ">" "[" "]" "," ";") (token 'OPERATOR lexeme)]
   [(:seq #\" (:* (:~ #\")) #\") (token 'STRING (substring lexeme 1 (- (string-length lexeme) 1)))]
   [digits (token 'INTEGER (string->number lexeme))]
   [(:or (:seq (:? digits) "." digits)
         (:seq digits ".")) (token 'DECIMAL (string->number lexeme))]
   [(:seq (:or alphabetic "_") (:* (:or alphabetic numeric "_"))) (token 'IDENTIFIER lexeme)]
   [(eof)      (void)]))

(provide basic-lexer)
