#lang brag

program : xdr-namespace-expr | xdr-config

xdr-namespace-expr : /"namespace" IDENTIFIER /"{" xdr-config* /"}"
xdr-config : xdr-const-expr | xdr-enum-expr | xdr-struct-expr | xdr-include-expr | xdr-typedef-expr

xdr-const-expr : /"const" xdr-const-name /"=" xdr-any-value
xdr-const-name : IDENTIFIER

xdr-enum-expr : /"enum" IDENTIFIER /"{" xdr-enum-member* (/"," xdr-enum-member)* /"}"
xdr-enum-member : IDENTIFIER /"=" xdr-any-value

xdr-struct-expr : /"struct" IDENTIFIER /"{" xdr-struct-member-line* LINE-SEP* /"}"
xdr-include-expr : /"%#include" xdr-string-value /";"
xdr-typedef-expr : /"typedef" IDENTIFIER IDENTIFIER /"<" xdr-any-value /">" /";"
                 | /"typedef" IDENTIFIER IDENTIFIER /"<" /">" /";"
                 | /"typedef" IDENTIFIER IDENTIFIER /"[" xdr-any-value /"]" /";"
                 | /"typedef" IDENTIFIER IDENTIFIER IDENTIFIER /";"
                 | /"typedef" IDENTIFIER IDENTIFIER /";"

xdr-struct-member-line : LINE-SEP xdr-struct-member /";"
xdr-struct-member : IDENTIFIER IDENTIFIER
xdr-file-path : STRING
xdr-any-value : xdr-integer-value | xdr-decimal-value | xdr-string-value
xdr-integer-value : INTEGER
xdr-decimal-value : DECIMAL
xdr-string-value : STRING