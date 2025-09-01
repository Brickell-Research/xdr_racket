#lang typed/racket

;; XDR Union
; A discriminated union is a type composed of a discriminant followed
;  by a type selected from a set of prearranged types according to the
;  value of the discriminant.  The type of discriminant is either "int",
;  "unsigned int", or an enumerated type, such as "bool".  The component
;  types are called "arms" of the union and are preceded by the value of
;  the discriminant that implies their encoding.  Discriminated unions
;  are declared as follows:
;
;        union switch (discriminant-declaration) {
;        case discriminant-value-A:
;           arm-declaration-A;
;        case discriminant-value-B:
;           arm-declaration-B;
;        ...
;        default: default-declaration;
;        } identifier;
;
;  Each "case" keyword is followed by a legal value of the discriminant.
;  The default arm is optional.  If it is not specified, then a valid
;  encoding of the union cannot take on unspecified discriminant values.
;  The size of the implied arm is always a multiple of four bytes.
;
;  The discriminated union is encoded as its discriminant followed by
;  the encoding of the implied arm.
;  0   1   2   3
;        +---+---+---+---+---+---+---+---+
;        |  discriminant |  implied arm  |          DISCRIMINATED UNION
;        +---+---+---+---+---+---+---+---+
;        |<---4 bytes--->|
