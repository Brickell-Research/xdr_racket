#lang scribble/manual
@require[scribble/eval
         (for-label typed/racket/base
                    xdr)]

@title{XDR}
@author[(author+email @elem{Rob Durst}
                      "me@robdurst.com")]

@defmodule[xdr]

This package provides a Racket implementation of the XDR (External Data Representation) protocol.

The process for leveraging XDR (@hyperlink["https://tools.ietf.org/html/rfc4506"]{RFC 4506}) is as follows:

@itemlist[#:style 'ordered
@item{
  Define XDR configuration files. As an example, the @hyperlink["https://github.com/stellar/stellar-xdr"]{Stellar Blockchain network uses XDR to define the structure of its messages}. An XDR enum might look like:
  @codeblock[#:line-numbers 0]{
    enum { 
      RED = 2,
      YELLOW = 3,
      BLUE = 5 
    } colors;
  }
}

@item{
  Use the @racket[xdr-parse] function to parse the XDR configuration files and generate Racket code.
  @racketblock[
    (xdr-parse "path/to/xdr/file")
    ;; This will generate Racket code in the current directory:
    ;;  (struct xdr-enum-colors((RED . 2) (YELLOW . 3) (BLUE . 5)))
  ]
}
@item{
  Use the generated Racket code to encode and decode XDR data.
  @racketblock[
    (xdr-enum-colors RED)
    (xdr-enum-colors 2)
  ]
}
]

@include-section["xdr_types.scrbl"]

@include-section["xdr_in_the_wild.scrbl"]

@include-section["license.scrbl"]
