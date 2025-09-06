#lang br
(require rackunit
         rackunit/text-ui
         racket/file
         racket/system
         racket/string)

(define (test-xdr-constant example-file-name expected-result-file-name)
  (define example-file (build-path (current-directory) "examples" example-file-name))
  (define expected-result-file (build-path (current-directory) "examples" expected-result-file-name))
  (define result
    (with-output-to-string
      (lambda ()
        (system (format "racket ~a" example-file)))))
  (check-equal? (string-trim result) (string-trim (file->string expected-result-file)) "Result does not match expected result"))

(define expander-tests
  (test-suite "expander tests"
              (test-case "simple constant"
                         (test-xdr-constant "just_constant.rkt" "just_constant_expected.txt"))
              (test-case "three constants"
                         (test-xdr-constant "three_constants.rkt" "three_constants_expected.txt"))))

(run-tests expander-tests)