#lang info

(define collection 'multi)
(define deps '("base" "typed-racket-lib" "brag" "br-parser-tools" "beautiful-racket" "rackunit"))
(define build-deps
  '("racket-doc"
    "scribble-lib"
    "rackunit-lib"
    "rackunit-typed"))
(define compile-omit-paths '("test.rkt"))
(define pkg-desc "XDR encoding, decoding, and generation library")
(define version "0.0.1")
(define pkg-authors '("Rob Durst"))
(define license 'AGPL-3.0-or-later)
(define scribblings '(("scribblings/xdr.scrbl" ())))
