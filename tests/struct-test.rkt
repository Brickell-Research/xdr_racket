#lang typed/racket

(require typed/rackunit typed/rackunit/text-ui)
(require "../xdr/struct.rkt")

;; MyRange struct equivalent to the JS test
;; struct MyRange {
;;   int begin;
;;   int end;
;;   bool inclusive;
;; }

(define-xdr-struct MyRange
  ([begin Number]
   [end Number]
   [inclusive Boolean]))

(define struct-tests
  (test-suite "struct tests"
              (test-case "MyRange empty constructor"
                         (let ([empty-range (MyRange-empty)])
                           (check-equal? (MyRange-begin empty-range) 0)
                           (check-equal? (MyRange-end empty-range) 0)
                           (check-equal? (MyRange-inclusive empty-range) #f)))))

(run-tests struct-tests)
