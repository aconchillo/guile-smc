;;; context.scm -- Guile-SMC finite state machine context.

;; Copyright (C) 2021 Artyom V. Poptsov <poptsov.artyom@gmail.com>
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; The program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with the program.  If not, see <http://www.gnu.org/licenses/>.


;;; Commentary:

;; This file contains an implementation of a generic context that can be used
;; with an FSM to provide a memory.


;;; Code:

(define-module (smc core context)
  #:use-module (oop goops)
  #:use-module (smc core log)
  #:use-module (smc core stack)
  #:export (<context>
            context-debug-mode?
            context-debug-mode-set!
            context-stanza
            context-stanza-set!
            context-stanza-clear!
            context-buffer
            context-buffer-set!
            context-buffer-clear!
            action:store
            action:update-stanza))

;; This class describes a generic parser context.
(define-class <context> ()
  ;; <boolean>
  (debug-mode?
   #:init-value #f
   #:init-keyword #:debug-mode?
   #:getter       context-debug-mode?
   #:setter       context-debug-mode-set!)

  ;; The buffer holds read symbols.
  ;;
  ;; <stack>
  (buffer
   #:init-value (make <stack>)
   #:getter     context-buffer
   #:setter     context-buffer-set!)

  ;; The stanza holds a logical unit of parsing (e.g. a key/value pair)
  ;;
  ;;<stack>
  (stanza
   #:init-value (make <stack>)
   #:getter     context-stanza
   #:setter     context-stanza-set!))



(define-method (context-buffer-clear! (ctx <context>))
  (stack-clear! (context-buffer ctx)))

(define-method (context-stanza-clear! (ctx <context>))
  (stack-clear! (context-stanza ctx)))



(define (action:store event ctx)
  (when (context-debug-mode? ctx)
    (log-debug "action:store: event: ~a; buffer: ~a"
               event (context-buffer ctx)))
  (stack-push! (context-buffer ctx) event)
  ctx)

(define (action:update-stanza event ctx)
  (let ((buf    (context-buffer ctx))
        (stanza (context-stanza ctx)))
    (unless (null? buf)
      (when (context-debug-mode? ctx)
        (log-debug "action:update-stanza: event: ~a; buffer: ~a; stanza: ~a"
                   event
                   (stack-content/reversed buf)
                   (stack-content/reversed stanza)))
      (stack-push! stanza (stack-content/reversed buf))
      (stack-clear! buf))
    ctx))

;;; context.scm ends here.
