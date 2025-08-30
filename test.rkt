#lang racket

(require rackunit
         rackunit/text-ui)
(require "tests/integer-test.rkt"
         "tests/hyper-test.rkt"
         "tests/boolean-test.rkt"
         "tests/string-test.rkt"
         "tests/opaque-test.rkt")

(define all-tests
  (test-suite
   "XDR Library Tests"
   integer-tests
   hyper-tests
   boolean-tests
   string-tests
   opaque-tests))

(run-tests all-tests)
