#lang typed/racket

(module+ main
  (require racket/cmdline)
  
  (command-line
   #:program "xdr-racket"
   #:usage-help
   "XDR encoding, decoding, and generation library"
   ""
   "A Racket library for XDR (External Data Representation) encoding and decoding."
   #:once-each
   [("--version") "Show version information"
    (displayln (format "xdr-racket version 0.0.1"))
    (exit 0)]
   #:args ()
   (displayln "XDR Racket library")
   (displayln "Use --help for available options")))
