#lang racket
(require rackunit
         rackunit/text-ui)
(require (prefix-in xdr: (submod "../../xdr/generator/main.rkt" reader)))

(define generator-tests
  (test-suite
   "Generator tests"
   (test-case
    "XDR language smoketest"
    (let* ([test-file "test.xdr"]
           [port (open-input-file test-file)]
           [module-stx (xdr:read-syntax test-file port)])
      (close-input-port port)
      (check-true (syntax? module-stx))
      (check-equal? (syntax-e (car (syntax-e module-stx))) 'module)
      (let ([module-body (syntax->datum module-stx)])
        (check-equal? (car module-body) 'module)
        (check-equal? (cadr module-body) 'basic-mod)
        (check-equal? (caddr module-body) 'expander)
        (let ([parse-tree (cadddr module-body)])
          (check-equal? parse-tree '(TOP_CONFIG (CONFIG (CONST_EXPR "const" "MAX_SIZE" "=" (ANY_VALUE 42)))))))))

   (test-case
    "XDR expander compilation test"
    ;; Test that the expander compiles without errors
    (let ([expander-path "../../xdr/generator/expander.rkt"])
      (check-true (file-exists? expander-path))
      ;; Try to require the expander - this will fail if there are syntax errors
      (check-not-exn (lambda () (dynamic-require expander-path #f)))))))

(run-tests generator-tests)