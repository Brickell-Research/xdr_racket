#lang racket

(require rackunit
         rackunit/text-ui
         "../xdr/enum.rkt"
         "../xdr/internal/common.rkt")

;; Enum Constants as XDR Data
(define EMPTY_XDR_ENUM (xdr-enum '()))
(define COLOR_XDR_ENUM (xdr-enum (list (cons 'RED 2) (cons 'YELLOW 3) (cons 'BLUE 5))))

;; Enum Constants as XDR Data
(define COLOR_XDR_ENUM_BYTES (integer->integer-bytes 2 4 #f #t))
(define NON_EXISTENT_COLOR_XDR_ENUM_BYTES (integer->integer-bytes 1 4 #f #t))


(define enum-tests
  (test-suite
   "XDR Enum Tests"
   (test-suite "Enum Fetch Tests"
               (test-case "Color Enum Found" (check-equal? 2 (xdr-enum-value-from-key COLOR_XDR_ENUM 'RED)))
               (test-case "Color Enum Not Found" (check-exn (lambda (exn) (check-true (exn? exn)))
                                                            (lambda () (xdr-enum-value-from-key COLOR_XDR_ENUM 'PURPLE))))
               (test-case "Color Enum Key From Value" (check-equal? 'RED (xdr-enum-key-from-value COLOR_XDR_ENUM 2))))
   (test-suite "Enum Encode Tests"
               (test-case "Color Enum Found" (check-equal? COLOR_XDR_ENUM_BYTES (xdr-enum-encode COLOR_XDR_ENUM 'RED)))
               (test-case "Color Enum Not Found" (check-exn (lambda (exn) (check-true (exn? exn)))
                                                            (lambda () (xdr-enum-encode COLOR_XDR_ENUM 'PURPLE)))))
   (test-suite "Enum Decode Tests"
               (test-case "Color Enum Found" (check-equal? 'RED (xdr-enum-decode COLOR_XDR_ENUM COLOR_XDR_ENUM_BYTES)))
               (test-case "Color Enum Not Found" (check-exn (lambda (exn) (check-true (exn? exn)))
                                                            (lambda () (xdr-enum-decode COLOR_XDR_ENUM NON_EXISTENT_COLOR_XDR_ENUM_BYTES)))))))

(run-tests enum-tests)
