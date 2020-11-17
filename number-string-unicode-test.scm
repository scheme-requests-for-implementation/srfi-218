(import
  (scheme base)
  (number-string-unicode))

(cond-expand
  (chibi
    (import (except (chibi test) test-equal))
    (define-syntax test-equal
      (syntax-rules ()
        ((_ args ...) (test args ...)))))
  (else (import (srfi 64))))

(test-begin "Number string unicode")

(test-group
  "Test number->numeral"

  (test-equal
    (string #\x9E9 #\. #\x9E7 #\x9EA #\x9E7 #\x9EB)
    (number->numeral 3.1415 #\x9E6))

  (test-equal
    "3.1415"
    (number->numeral 3.1415 #\0))

  (test-equal
    (string #\x9E9 #\/ #\x9EA)
    (number->numeral 3/4 #\x9E6))

  (test-equal
    "3/4"
    (number->numeral 3/4 #\0)))

(test-group
  "Test numeral->number"

  (test-equal
    3.1415
    (numeral->number (string #\x9E9 #\. #\x9E7 #\x9EA #\x9E7 #\x9EB) #\x9E6))

  (test-equal
    3.1415
    (numeral->number "3.1415" #\0))

  (test-equal
    3/4
    (numeral->number (string #\x9E9 #\/ #\x9EA) #\x9E6))

  (test-equal
    3/4
    (numeral->number "3/4" #\0))

  (test-equal
    #f
    (numeral->number (string #\x9E9 #\/ #\4) #\0))

  ;; test explicit radix
  (test-equal
    #f
    (numeral->number "#b10" #\0))

  (test-equal
    #f
    (numeral->number "#o10" #\0))

  (test-equal
    10
    (numeral->number "#d10" #\0))

  (test-equal
    #f
    (numeral->number "#x10" #\0))

  ;; test explicit exactness specifier
  (test-equal
    10.0
    (numeral->number "#i10" #\0))

  (test-equal
    10
    (numeral->number "#e10" #\0))

  ;; test explicit radix and explicit exactness specifier
  (test-equal
    #f
    (numeral->number "#b#i10" #\0))

  (test-equal
    #f
    (numeral->number "#b#e10" #\0))

  (test-equal
    #f
    (numeral->number "#o#i10" #\0))

  (test-equal
    #f
    (numeral->number "#o#e10" #\0))

  (test-equal
    10.0
    (numeral->number "#d#i10" #\0))

  (test-equal
    10
    (numeral->number "#d#e10" #\0))

  (test-equal
    #f
    (numeral->number "#x#i10" #\0))

  (test-equal
    #f
    (numeral->number "#x#e10" #\0))

  ;; test explicit exactness specifier and explicit radix
  (test-equal
    #f
    (numeral->number "#i#b10" #\0))

  (test-equal
    #f
    (numeral->number "#e#b10" #\0))

  (test-equal
    #f
    (numeral->number "#i#o10" #\0))

  (test-equal
    #f
    (numeral->number "#e#o10" #\0))

  (test-equal
    10.0
    (numeral->number "#i#d10" #\0))

  (test-equal
    10
    (numeral->number "#e#d10" #\0))

  (test-equal
    #f
    (numeral->number "#i#x10" #\0))

  (test-equal
    #f
    (numeral->number "#e#x10" #\0)))

(test-end)

