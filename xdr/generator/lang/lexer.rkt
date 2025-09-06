#lang racket

(require br-parser-tools/lex
         brag/support)

(define-lex-abbrev digits (:+ (char-set "0123456789")))

;; Create the basic lexer
(define basic-lexer
  (lexer-srcloc
   [(from/to "//" "\n") (token 'COMMENT lexeme)]
   [whitespace (token lexeme #:skip? #t)]
   ["const" (token 'const lexeme)]
   ["enum" (token 'enum lexeme)]
   ["struct" (token 'struct lexeme)]
   ["typedef" (token 'typedef lexeme)]
   ["namespace" (token 'namespace lexeme)]
   ["%#include" (token '%#include lexeme)]
   ["=" (token "=" lexeme)]
   ["{" (token "{" lexeme)]
   ["}" (token "}" lexeme)]
   ["<" (token "<" lexeme)]
   [">" (token ">" lexeme)]
   ["[" (token "[" lexeme)]
   ["]" (token "]" lexeme)]
   ["," (token "," lexeme)]
   [";" (token ";" lexeme)]
   [(:seq #\" (:* (:~ #\")) #\") (token 'STRING (substring lexeme 1 (- (string-length lexeme) 1)))]
   [digits (token 'INTEGER (string->number lexeme))]
   [(:or (:seq (:? digits) "." digits)
         (:seq digits ".")) (token 'DECIMAL (string->number lexeme))]
   [(:seq (:or alphabetic "_") (:* (:or alphabetic numeric "_"))) (token 'IDENTIFIER (string->symbol lexeme))]
   [(eof)      (void)]))

(provide basic-lexer)
