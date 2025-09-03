#lang scribble/manual

@title{XDR Data Types}

This implementation provides the following XDR data types as defined in RFC 4506:

@itemlist[
@item{@racket[xdr-int]: 32-bit signed integers in two's complement notation, range [-2147483648, 2147483647]}
@item{@racket[xdr-uint]: 32-bit unsigned integers, range [0, 4294967295]}
@item{@racket[xdr-hyper]: 64-bit signed integers in two's complement notation}
@item{@racket[xdr-uhyper]: 64-bit unsigned integers, range [0, 18446744073709551615]}
@item{@racket[xdr-boolean]: Boolean values encoded as 32-bit integers (0 for FALSE, 1 for TRUE)}
@item{@racket[xdr-string]: Variable-length ASCII strings with length prefix and padding}
@item{@racket[xdr-opaque]: Variable-length opaque data with length prefix and padding}
@item{@racket[xdr-fixed-opaque]: Fixed-length opaque data with padding to 4-byte boundaries}
@item{@racket[xdr-float]: Single-precision floating-point numbers in IEEE 754 format}
@item{@racket[xdr-double]: Double-precision floating-point numbers in IEEE 754 format}
]

@bold{Note:} we do not support the following:
@item{@racket[xdr-union]: Union data type}
@item{@racket[xdr-quadruple]: Quadruple-precision floating-point numbers in IEEE 754 format}

Each type includes encoding and decoding functions following the pattern @racket[xdr-encode-TYPE] and @racket[xdr-decode-TYPE].
