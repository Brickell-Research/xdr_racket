#lang br/quicklang

(require "parser.rkt"
         (for-syntax syntax/parse "parser.rkt"))

(define-for-syntax (parse-xdr-config EXPR)
  (syntax-parse EXPR
    [(xdr-const-expr NAME EXPR) #'(xdr-const-expr NAME EXPR)]
    [(xdr-enum-expr NAME MEMBERS ...) #'(xdr-enum-expr NAME MEMBERS ...)]
    [(xdr-struct-expr NAME MEMBERS ...) #'(xdr-struct-expr NAME MEMBERS ...)]
    [(xdr-include-expr FILE) #'(xdr-include-expr FILE)]
    [(xdr-typedef-expr NAME TYPE) #'(xdr-typedef-expr NAME TYPE)]
    [(xdr-any-value VALUE) #'(xdr-any-value VALUE)]))

(define-macro (xdr-config EXPR)
  (parse-xdr-config #'EXPR))

;; Define all parser identifiers as pass-through functions
;; -- constants --
(define-macro (xdr-const-expr (xdr-const-name NAME) VALUE) #`(list 'define (quote #,(syntax->datum #'NAME)) VALUE))
(define-macro (xdr-const-name NAME) #'NAME)

;; -- enums --
(define-macro (xdr-enum-expr NAME . MEMBERS) #'(list 'enum NAME (list . MEMBERS)))
(define-macro (xdr-enum-member NAME VALUE) #'(list NAME VALUE))

;; -- structs --
(define-macro (xdr-struct-expr NAME . MEMBERS) #'(list 'struct NAME (list . MEMBERS)))
(define-macro (xdr-struct-member-line MEMBER) #'MEMBER)
(define-macro (xdr-struct-member TYPE NAME) #'(list TYPE NAME))

;; -- includes --
(define-macro (xdr-include-expr FILE) #'(list 'include FILE))

;; -- typedefs --
(define-macro (xdr-typedef-expr . ARGS) #'(list 'typedef . ARGS))
(define-macro (xdr-any-value VALUE) #'VALUE)
(define-macro (xdr-integer-value VALUE) #'VALUE)
(define-macro (xdr-decimal-value VALUE) #'VALUE)
(define-macro (xdr-string-value VALUE) #'VALUE)

;; First macro executed when the program begins
(define-macro (xdr-module-begin (program XDR-CONFIG ...))
  #'(#%module-begin
     XDR-CONFIG ...))
(provide (rename-out [xdr-module-begin #%module-begin])
         xdr-config
         xdr-const-expr
         xdr-const-name
         xdr-enum-expr
         xdr-enum-member
         xdr-struct-expr
         xdr-struct-member-line
         xdr-struct-member
         xdr-include-expr
         xdr-typedef-expr
         xdr-any-value
         xdr-integer-value
         xdr-decimal-value
         xdr-string-value)

