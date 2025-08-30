#lang racket

(require rackunit
         rackunit/text-ui)
(require "tests/integer-test.rkt"
         "tests/hyper-test.rkt"
         "tests/boolean-test.rkt")

(define all-tests
  (test-suite
   "XDR Library Tests"
   integer-tests
   hyper-tests
   boolean-tests))

(run-tests all-tests)
