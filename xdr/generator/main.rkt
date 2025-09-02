#lang br/quicklang
(require "parser.rkt" "tokenizer.rkt" "expander.rkt" "grammar.rkt")

(define (read-syntax path port)
  (define parse-tree (parse path (make-tokenizer port path)))
  (strip-bindings
   #`(module basic-mod expander
       #,parse-tree)))

(module+ reader
  (provide read-syntax))

(provide parse-expr)