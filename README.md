# xdr

[![Racket Package](https://img.shields.io/badge/raco%20pkg%20install-XDR-blue.svg?logo=racket)](https://pkgd.racket-lang.org/pkgn/package/XDR)
[![Unit Tests](https://github.com/robertDurst/xdr_racket/actions/workflows/unit-tests.yml/badge.svg)](https://github.com/robertDurst/xdr_racket/actions/workflows/unit-tests.yml)

> **⚠️ WARNING: This library is currently in development and is not yet ready for production use.**

XDR encoding, decoding, and generation library for the Racket Programming Language.

XDR is a data representation standard defined in [RFC 4506](https://tools.ietf.org/html/rfc4506).

This library is motivated by my work with XDR at the [Stellar Development Foundation](https://www.stellar.org/) and thus took inspiration from:

* [Stellar's JS XDR](https://github.com/stellar/js-xdr)
* [Stellar's Go XDR](https://github.com/stellar/go/tree/master/xdr)

***

## Project Status

* [x] Integer
* [x] Unsigned Integer
* [x] Hyper Integer
* [x] Unsigned Hyper Integer
* [x] Boolean
* [ ] Enumeration
* [ ] Floating Point
* [ ] Double-Precision Floating-Point
* [ ] Quadruple-Precision Floating-Point
* [x] Fixed-Length Opaque Data
* [x] Variable-Length Opaque Data
* [x] String
* [ ] Fixed-Length Array
* [ ] Variable-Length Array
* [ ] Structure
* [ ] Discriminated Union
* [ ] Void
* [ ] Constant
* [ ] Typedef
* [ ] Optional-Data

## Support

If you find this library helpful, consider supporting my work:

[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-support-yellow.svg?style=flat-square&logo=buy-me-a-coffee)](https://buymeacoffee.com/rdurst)
