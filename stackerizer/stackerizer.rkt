#lang br/quicklang
(provide + *)

(define-macro (stackerizer-mb EXPR)
  #'(#%module-begin
     (for-each displayln (reverse (flatten EXPR)))))
(provide (rename-out [stackerizer-mb #%module-begin]))

;; Matches syntax patterns for single value and ulti-value operations.
(define-macro-cases +
  [(+ FIRST) #'FIRST]
  ;; Matches a variadic addition operation.
  ;; Recursively transforms the operation into a dyadic one by repeatedly nesting operations.
  ;; NB: '+ is the literal plus sign, while + refers to the ID of this macro.
  [(+ FIRST NEXT ...) #'(list '+ FIRST (+ NEXT ...))])

