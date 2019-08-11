#lang br/quicklang

(define (read-syntax path port)
  ;; Read all of the source lines via the port into the src-lines variable
  ;; (a list of strings).
  (define src-lines (port->lines port))

  ;; Convert each source line into a datum.
  ;; format-datums maps over each list element and converts them with
  ;; a format string '(handle ~a) where ~a is replaced by the value
  ;; of each element.
  (define src-datums (format-datums '(handle ~a) src-lines))

  ;; We use the backtick (quasiquote) which lets us insert variables
  ;; into the following expression.
  ;; , is the unquote operator which substitutes the variable for its value.
  ;; ,@ is a special form of the unquote operator which destructures the input,
  ;; in this case unpacking the list of (handle x) function calls.
  (define module-datum `(module stacker-mod "stacker.rkt"
                          ,@src-datums))

  ;; Return a module as a syntax-object.
  (datum->syntax #f module-datum))

(provide read-syntax)

;; We define a macro - stacker-module-begin - which performs some processing
;; and then passes the input values to the next #%module-begin in the chain.
;;
;; Unlike functions, macros are defined with syntax patterns - analogous
;; to a regular expression that breaks down the input into pieces (destructuring).
(define-macro (stacker-module-begin HANDLE-EXPR ...)
  ;; #' converts the following code into a syntax object while also capturing
  ;; the lexical context (all variables in scope)
  #'(#%module-begin
     HANDLE-EXPR ...
     (display (first stack))))

;; We rename stacker-module-begin to #%module-begin so Racket knows to call it.
(provide (rename-out [stacker-module-begin #%module-begin]))

;; Define a stack to store numbers.
(define stack empty)

;; Removes the top element from the stack, setting the stack to contain only
;; values after the first.
;; By convention, Racket functions which mutate a variable and with an !
(define (pop-stack!)
  (define arg (first stack))
  (set! stack (rest stack))
  arg)

(define (push-stack! arg)
  ;; cons is one of the oldest Lisp functions, which constructs a new item in
  ;; memory. What we're doing here is prepending arg to stack to form a new
  ;; stack, which we set the original stack variable to.
  (set! stack (cons arg stack)))


;; [arg #f] declares arg as an optional argument.
(define (handle [arg #f])
  (cond
   ;; If the value is a number, push it to the stack.
   [(number? arg) (push-stack! arg)]
   ;; If the value is an operator, perform the operation against two numbers
   ;; popped from the stack.
   [(or (equal? + arg) (equal? * arg))
    (define op-result (arg (pop-stack!) (pop-stack!)))
    (push-stack! op-result)]))
(provide handle)

(provide * +)
