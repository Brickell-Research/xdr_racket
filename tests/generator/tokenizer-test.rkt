#lang racket

(require rackunit
         rackunit/text-ui)
(require "../../xdr/generator/lang/tokenizer.rkt"
         brag/support)

(define tokenizer-tests
  (test-suite
   "tokenizer tests"
   (test-case
    "simple integer"
    (define tokenizer (make-tokenizer (open-input-string "123")))
    (define token (tokenizer))
    (check-true (srcloc-token? token))
    (define inner-token (srcloc-token-token token))
    (check-equal? (token-struct-type inner-token) 'INTEGER)
    (check-equal? (token-struct-val inner-token) 123))

   (test-case
    "eof"
    (define tokenizer (make-tokenizer (open-input-string "")))
    (define token (tokenizer))
    (check-true (srcloc-token? token))
    (check-true (void? (srcloc-token-token token))))))

(run-tests tokenizer-tests)
