#lang br/quicklang

(define (read-syntax path port)
  ;; Read all of the source lines via the port into the src-lines variable
  ;; (a list of strings).
  (define src-lines (port->lines port))

  ;; Return a module as a syntax-object.
  ;; This module uses the br expander from br/quicklang to evaluate 42.
  (datum->syntax #f '(module lucy br
                       42)))
(provide read-syntax)
