(define-module (smc compiler)
  #:use-module (oop goops)
  #:use-module (ice-9 pretty-print)
  #:use-module (smc core state)
  #:use-module (smc fsm)
  #:export (fsm-compile
            %write-module
            %write-transition-table))



(define (%write-header port)
  (display ";;; Generated by Guile-SMC\n\n" port))

(define (%write-module module class-name port)
  (pretty-print `(define-module ,module
                   #:use-module (smc fsm)
                   #:export (list ,class-name))
                port)
  (newline port))

(define-method (%write-transition-table (fsm <fsm>) (port <port>))
  (let ((table (fsm-transition-table fsm)))
    (pretty-print
     `(define %transition-table
        ,(list 'quasiquote
               (map (lambda (state)
                      (cons
                       (car state)
                       (map (lambda (tr)
                              (map (lambda (e)
                                     (if (procedure? e)
                                         (list 'unquote (procedure-name e))
                                         e))
                                   tr))
                            (cdr state))))
                    (hash-table->transition-list table))))
     port)))



(define* (fsm-compile fsm
                      #:key
                      (fsm-name 'custom-fsm)
                      (module   #f)
                      (output-port (current-output-port)))
  (%write-header output-port)
  (let ((class-name (string->symbol (format #f "<~a>" fsm-name))))
    (if module
        (%write-module module class-name output-port)
        (display '(use-modules (smc fsm))
                 output-port))

    (newline output-port)

    (%write-transition-table fsm output-port)

    (newline output-port)

    (pretty-print `(define-class ,class-name (<fsm>))
                  output-port)

    (newline output-port)

    (pretty-print
     `(define-method (initialize (self ,class-name) initargs)
        (fsm-transition-table-set!
         self
         (transition-list->hash-table %transition-table))
        (fsm-current-state-set! self
                                (fsm-state self
                                           ,(state-name (fsm-current-state fsm))))))

    (newline output-port)))
