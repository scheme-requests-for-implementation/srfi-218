(define-library
  (number-string-unicode)

  (import
    (scheme base)
    (scheme char)
    (scheme case-lambda))
  (export
    numeral->number
    number->numeral)

  (include "number-string-unicode-impl.scm"))
