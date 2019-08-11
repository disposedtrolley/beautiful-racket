#lang br/quicklang

(define (read-syntax path port)
  ;; Read all of the source lines via the port into the src-lines variable
  ;; (a list of strings).
  (define src-lines (port->lines port))

  ;; Convert each source line into a datum.
  ;; format-datums maps over each list element and converts them with
  ;; a format string '(handle ~a) where ~a is replaced by the value
  ;; of each element.
  (define src-datums (format-datums ''(handle ~a) src-lines))

  ;; We use the backtick (quasiquote) which lets us insert variables
  ;; into the following expression.
  ;; , is the unquote operator which substitutes the variable for its value.
  ;; ,@ is a special form of the unquote operator which destructures the input,
  ;; in this case unpacking the list of (handle x) function calls.
  (define module-datum `(module stacker-mod br
                          ,@src-datums))

  ;; Return a module as a syntax-object.
  (datum->syntax #f module-datum))

(provide read-syntax)
