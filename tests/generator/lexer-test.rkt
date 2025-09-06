#lang br
(require "../../xdr/generator/lang/lexer.rkt" brag/support rackunit rackunit/text-ui)
(require br-parser-tools/lex
         brag/support)

(define (test-lexer input)
  (basic-lexer (open-input-string input)))

(define lexer-tests
  (test-suite "lexer tests"
              (test-case "whitespace"
                         (check-equal? (test-lexer "\t") (srcloc-token
                                                          (token-struct '|	| #f #f #f #f #f #t)
                                                          (srcloc 'string #f #f 1 1))))
              (test-case "comment"
                         (check-equal? (test-lexer "// This is a comment\n") (srcloc-token
                                                                              (token-struct 'COMMENT "// This is a comment\n" #f #f #f #f #f)
                                                                              (srcloc 'string #f #f 1 21))))
              (test-case "integer"
                         (check-equal? (test-lexer "123") (srcloc-token
                                                           (token-struct 'INTEGER 123 #f #f #f #f #f)
                                                           (srcloc 'string #f #f 1 3))))
              (test-case "decimal"
                         (check-equal? (test-lexer "123.45") (srcloc-token
                                                              (token-struct 'DECIMAL 123.45 #f #f #f #f #f)
                                                              (srcloc 'string #f #f 1 6))))
              (test-case "simple string"
                         (check-equal? (test-lexer "\"hello\"") (srcloc-token
                                                                 (token-struct 'STRING "hello" #f #f #f #f #f)
                                                                 (srcloc 'string #f #f 1 7))))
              (test-case "more complex string"
                         (check-equal? (test-lexer "\"hello world!\"") (srcloc-token
                                                                        (token-struct 'STRING "hello world!" #f #f #f #f #f)
                                                                        (srcloc 'string #f #f 1 14))))
              (test-case "keyword"
                         (check-equal? (test-lexer "const") (srcloc-token
                                                             (token-struct 'const "const" #f #f #f #f #f)
                                                             (srcloc 'string #f #f 1 5))))
              (test-case "operator"
                         (check-equal? (test-lexer "=") (srcloc-token
                                                         (token-struct '= "=" #f #f #f #f #f)
                                                         (srcloc 'string #f #f 1 1))))
              (test-case "identifier"
                         (check-equal? (test-lexer "hello") (srcloc-token
                                                             (token-struct 'IDENTIFIER "hello" #f #f #f #f #f)
                                                             (srcloc 'string #f #f 1 5))))
              (test-case "eof"
                         (check-equal? (test-lexer "") (srcloc-token (void) (srcloc 'string #f #f 1 0))))))

(run-tests lexer-tests)