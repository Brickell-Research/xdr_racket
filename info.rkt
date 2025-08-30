#lang info

(define collection "xdr")
(define deps '("base" "typed-racket-lib"))
(define build-deps
  '("racket-doc"
    "scribble-lib"
    "rackunit-lib"
    "rackunit-typed"))
(define pkg-desc "XDR encoding, decoding, and generation library")
(define version "0.0.1")
(define pkg-authors '("Rob Durst"))
(define license 'AGPL-3.0-or-later)
