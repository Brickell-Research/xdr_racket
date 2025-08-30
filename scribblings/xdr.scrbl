#lang scribble/manual

@title{XDR}
@author[(author+email @elem{Rob Durst}
                      "me@robdurst.com")]

@defmodule[xdr]

This package provides a Racket implementation of the XDR (External Data Representation) protocol.

@section{XDR Types}

This implementation provides the following XDR data types as defined in RFC 4506:

@subsection{Integer Types}
@itemlist[
@item{@racket[xdr-int]: 32-bit signed integers in two's complement notation, range [-2147483648, 2147483647]}
@item{@racket[xdr-uint]: 32-bit unsigned integers, range [0, 4294967295]}
@item{@racket[xdr-hyper]: 64-bit signed integers in two's complement notation}
@item{@racket[xdr-uhyper]: 64-bit unsigned integers, range [0, 18446744073709551615]}
@item{@racket[xdr-boolean]: Boolean values encoded as 32-bit integers (0 for FALSE, 1 for TRUE)}
@item{@racket[xdr-string]: Variable-length ASCII strings with length prefix and padding}
@item{@racket[xdr-opaque]: Variable-length opaque data with length prefix and padding}
@item{@racket[xdr-fixed-opaque]: Fixed-length opaque data with padding to 4-byte boundaries}
]

Each type includes encoding and decoding functions following the pattern @racket[xdr-encode-TYPE] and @racket[xdr-decode-TYPE].

@section{License}

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but @bold{without any waranty;} without even the implied warranty of
@bold{merchantability} or @bold{fitness for a particular purpose.}
See the GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program. If not, see @url["https://www.gnu.org/licenses/"].