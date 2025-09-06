#lang br/quicklang

;; Macro that expands to the list of configs skipping the top level program macro
(define-macro (xdr-program CONFIG ...)
  #'(CONFIG ...))

;; First macro executed when the program begina
(define-macro (xdr-module-begin (xdr-program CONFIG ...))
  #'(#%module-begin
     CONFIG ...))
(provide (rename-out [xdr-module-begin #%module-begin]))
