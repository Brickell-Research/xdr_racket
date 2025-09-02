#lang racket
(require (for-syntax racket/syntax))
(provide (all-defined-out))

;; Basic expander - just returns the parse tree for now
(define-syntax (basic-mod stx)
  (syntax-case stx ()
    [(_ . PARSE-TREE)
     #'(module basic-mod racket
         (provide parse-tree)
         (define parse-tree 'PARSE-TREE))]))