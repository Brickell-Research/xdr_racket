#lang typed/racket

(provide xdr-void xdr-decode-void xdr-encode-void)

;; XDR Void
;  An XDR void is a 0-byte quantity.  Voids are useful for describing
;    operations that take no data as input or no data as output.  They are
;    also useful in unions, where some arms may contain data and others do
;    not.  The declaration is simply as follows:
;
;          void;
;
;    Voids are illustrated as follows:
;
;            ++
;            ||                                                     VOID
;            ++
;          --><-- 0 bytes
(: xdr-void (-> Void))
(define (xdr-void) (void))

(: xdr-decode-void (-> Bytes Void))
(define (xdr-decode-void bstr) (void))

(: xdr-encode-void (-> Void Bytes))
(define (xdr-encode-void v) #"")
