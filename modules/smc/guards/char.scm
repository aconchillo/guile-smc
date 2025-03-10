;; This module contains some common state machine transition guards.

(define-module (smc guards char)
  #:export (guard:#t
            guard:asterisk?
            guard:equals-sign?
            guard:newline?
            guard:hyphen-minus?
            guard:space?
            guard:less-than-sign?
            guard:letter?
            guard:more-than-sign?
            guard:colon?
            guard:semicolon?
            guard:eof-object?
            guard:single-quote?
            guard:left-square-bracket?
            guard:right-square-bracket?
            guard:at-symbol?))

(define (guard:#t event ctx)
  "This guard is always returns #t."
  #t)

(define (guard:equals-sign? ch ctx)
  (char=? ch #\=))

(define (guard:newline? ch ctx)
  (char=? ch #\newline))

(define (guard:hyphen-minus? ch ctx)
  (char=? ch #\-))

(define (guard:space? ch ctx)
  (char=? ch #\space))

(define (guard:less-than-sign? ch ctx)
  (char=? ch #\<))

(define (guard:more-than-sign? ch ctx)
  (char=? ch #\>))

(define (guard:letter? ch ctx)
  (char-set-contains? char-set:letter ch))

(define (guard:eof-object? ch ctx)
  (eof-object? ch))

(define (guard:single-quote? ch ctx)
  (char=? ch #\'))

(define (guard:colon? ch ctx)
  (char=? ch #\:))

(define (guard:semicolon? ch ctx)
  (char=? ch #\;))

(define (guard:left-square-bracket? ch ctx)
  (char=? ch #\[))

(define (guard:right-square-bracket? ch ctx)
  (char=? ch #\]))

(define (guard:at-symbol? ch ctx)
  (char=? ch #\@))

(define (guard:asterisk? ch ctx)
  (char=? ch #\*))
