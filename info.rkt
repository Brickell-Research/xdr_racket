#lang info

(define collection "xdr")
(define deps '("base"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/xdr.scrbl" ())))
(define pkg-desc "XDR encoding, decoding, and generation library")
(define version "0.0.1")
(define pkg-authors '("Rob Durst"))
(define license 'GPL-3.0)
