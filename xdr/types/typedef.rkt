#lang typed/racket

;; XDR Typedef
;    "typedef" does not declare any data either, but serves to define new
;    identifiers for declaring data.  The syntax is:
;
;          typedef declaration;
;
;    The new type name is actually the variable name in the declaration
;    part of the typedef.  For example, the following defines a new type
;    called "eggbox" using an existing type called "egg":
;
;          typedef egg eggbox[DOZEN];
;
;    Variables declared using the new type name have the same type as the
;    new type name would have in the typedef, if it were considered a
;    variable.  For example, the following two declarations are equivalent
;    in declaring the variable "fresheggs":
;
;          eggbox  fresheggs; egg     fresheggs[DOZEN];
;
;    When a typedef involves a struct, enum, or union definition, there is
;    another (preferred) syntax that may be used to define the same type.
;    In general, a typedef of the following form:
;
;          typedef <<struct, union, or enum definition>> identifier;
;
;    may be converted to the alternative form by removing the "typedef"
;    part and placing the identifier after the "struct", "union", or
;    "enum" keyword, instead of at the end.  For example, here are the two
;    ways to define the type "bool":
;
;          typedef enum {    /* using typedef */
;             FALSE = 0,
;             TRUE = 1
;          } bool;
;
;          enum bool {       /* preferred alternative */
;             FALSE = 0,
;             TRUE = 1
;          };
;
;    This syntax is preferred because one does not have to wait until the
;    end of a declaration to figure out the name of the new type.

(struct xdr-typedef ([name : Symbol] [type : Symbol]) #:transparent)

;; No encoder or decoder since it "does not declare any data".
