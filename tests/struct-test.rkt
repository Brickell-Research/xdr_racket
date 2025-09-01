#lang typed/racket

(require typed/rackunit typed/rackunit/text-ui)
(require "../xdr/struct.rkt")

;; MyRange struct equivalent to the JS test
;; struct MyRange {
;;   int begin;
;;   int end;
;;   bool inclusive;
;; }

;; Test struct with different XDR types
;; struct TestStruct {
;;   string name;
;;   uint32 count;
;;   bool active;
;; }

(define-xdr-struct MyRange
  ([begin Integer]
   [end Integer]
   [inclusive Boolean]))

(define-xdr-struct TestStruct
  ([name String]
   [count Natural]
   [active Boolean]))

;; MyRange test constants
(define MYRANGE_10_20_TRUE (MyRange 10 20 #t))
(define MYRANGE_5_15_FALSE (MyRange 5 15 #f))
(define MYRANGE_NEG10_NEG5_TRUE (MyRange -10 -5 #t))

;; MyRange expected byte constants
(define MYRANGE_10_20_TRUE_BYTES #"\x00\x00\x00\x0a\x00\x00\x00\x14\x00\x00\x00\x01")
(define MYRANGE_5_15_FALSE_BYTES #"\x00\x00\x00\x05\x00\x00\x00\x0f\x00\x00\x00\x00")
(define MYRANGE_NEG10_NEG5_TRUE_BYTES #"\xff\xff\xff\xf6\xff\xff\xff\xfb\x00\x00\x00\x01")

;; TestStruct test constants
(define TESTSTRUCT_HELLO_42_TRUE (TestStruct "hello" 42 #t))

;; TestStruct expected byte constants
(define TESTSTRUCT_HELLO_42_TRUE_BYTES #"\x00\x00\x00\x05hello\x00\x00\x00\x00\x00\x00\x2a\x00\x00\x00\x01")

(define struct-tests
  (test-suite "struct tests"
              (test-suite "Empty constructor"
                          (test-case "MyRange empty constructor"
                                     (let ([empty-range (MyRange-empty)])
                                       (check-equal? (MyRange-begin empty-range) 0)
                                       (check-equal? (MyRange-end empty-range) 0)
                                       (check-equal? (MyRange-inclusive empty-range) #f))))

              (test-suite "to-bytes encoding"
                          (test-case "MyRange to-bytes encoding"
                                     (define encoded (MyRange-to-bytes MYRANGE_10_20_TRUE))
                                     (check-equal? encoded MYRANGE_10_20_TRUE_BYTES))

                          (test-case "MyRange to-bytes with false boolean"
                                     (define encoded (MyRange-to-bytes MYRANGE_5_15_FALSE))
                                     (check-equal? encoded MYRANGE_5_15_FALSE_BYTES))

                          (test-case "MyRange to-bytes with negative numbers"
                                     (define encoded (MyRange-to-bytes MYRANGE_NEG10_NEG5_TRUE))
                                     (check-equal? encoded MYRANGE_NEG10_NEG5_TRUE_BYTES))

                          (test-case "TestStruct empty constructor"
                                     (let ([empty-test (TestStruct-empty)])
                                       (check-equal? (TestStruct-name empty-test) "")
                                       (check-equal? (TestStruct-count empty-test) 0)
                                       (check-equal? (TestStruct-active empty-test) #f)))

                          (test-case "TestStruct to-bytes encoding with string"
                                     (define encoded (TestStruct-to-bytes TESTSTRUCT_HELLO_42_TRUE))
                                     (check-equal? encoded TESTSTRUCT_HELLO_42_TRUE_BYTES)))))

(run-tests struct-tests)
