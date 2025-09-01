#lang racket
(require brag/support
         "grammar.rkt"
         "lexer.rkt")

(define (parse-expr s)
  (parse (lex (open-input-string s)))) ; returns a simple parse tree s-expression


(provide parse-expr)
