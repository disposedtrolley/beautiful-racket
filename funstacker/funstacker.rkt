#lang br/quicklang

(define (read-syntax path port)
  (define src-lines (port->lines port))
  (define src-datums (format-datums '~a src-lines))
  (define module-datum `(module funstacker-mod "funstacker.rkt"
                          (handle-args ,@src-datums)))
  (datum->syntax #f module-datum))

(provide read-syntax)

(define-macro (funstacker-module-begin HANDLE-ARGS-EXPR)
  #'(#%module-begin
     (display (first HANDLE-ARGS-EXPR))))
(provide (rename-out [funstacker-module-begin #%module-begin]))

(define (handle-args . args)
  ;; Iterate over inputs while maintaining an accumulator of the current result.
  (for/fold ([stack-acc empty])
      ([arg (in-list args)]
       #:unless (void? arg))
    ;; If the current value is a number, push it into the stack.
    ;; If the current value is an operator, take the first and second values from the stack,
    ;; perform the operation, pop the values off the stack, and then push the accumulator
    ;; onto the stack.
    (cond
     [(number? arg) (cons arg stack-acc)]
     [(or (equal? * arg) (equal? + arg))
      (define op-result
        (arg (first stack-acc) (second stack-acc)))
      (cons op-result (drop stack-acc 2))])))
(provide handle-args)

(provide * +)
