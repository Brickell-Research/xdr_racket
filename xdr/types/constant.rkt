#lang typed/racket

(provide xdr-constant xdr-constant?)

;; XDR Constant
;  The data declaration for a constant follows this form:
;
;        const name-identifier = n;
;
;  "const" is used to define a symbolic name for a constant; it does not
;  declare any data.  The symbolic constant may be used anywhere a
;  regular constant may be used.  For example, the following defines a
;  symbolic constant DOZEN, equal to 12.
;
;        const DOZEN = 12;
(struct xdr-constant ([name : Symbol] [value : Integer]) #:transparent)

;; No encoder or decoder since it "does not declare any data".
