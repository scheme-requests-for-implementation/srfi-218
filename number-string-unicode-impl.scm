(define (number->numeral z zero)
  (define zero-code (char->integer zero))
  (define str (number->string z))
  (define l (string-length str))
  (do ((i 0 (+ 1 i)))
      ((= i l) str)
      (let* ((char (string-ref str i))
             (digit (digit-value char))
             (replace-char
               (if digit
                   (integer->char (+ zero-code digit))
                   char)))
        (string-set! str i replace-char)))
  str)

(define ascii-zero-code (char->integer #\0))
(define (normalize-char char zero-code)
  (define digit (digit-value char))
  (define digit-right-type?
    (and digit
         (equal? char (integer->char (+ digit zero-code)))))
  (cond
    ((and digit digit-right-type?)
     (integer->char (+ digit ascii-zero-code)))
    ;; return rubbish char when received
    ;; digit-like char but from wrong set
    (digit
      #\?)
    ;; pass through other chars (eg decimal and fraction)
    (else char)))

(define (non-decimal-radix-prefix? str)
  (cond
    ((< (string-length str) 2) #f)
    ((not (equal? #\# (string-ref str 0))) #f)
    ((equal? #\d (string-ref str 1)) #f)
    ;; if it starts with exactness specifier
    ;; also check third and fourth letters
    ((or (equal? #\i (string-ref str 1))
         (equal? #\e (string-ref str 1)))
     (cond
       ((< (string-length str) 4) #f)
       ((not (equal? #\# (string-ref str 2))) #f)
       ((equal? #\d (string-ref str 3)) #f)
       (else #t)))
    (else #t)))

(define (numeral->number str zero)
  ;; only pass through decimal radix
  (if (non-decimal-radix-prefix? str)
      #f
      (let* ((zero-code (char->integer zero))
             (char-mapper (lambda (char)
                            (normalize-char char zero-code)))
             (basic-str (string-map char-mapper str)))
        (string->number basic-str))))
