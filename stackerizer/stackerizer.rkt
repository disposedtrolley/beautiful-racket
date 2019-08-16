#lang br/quicklang
(provide + *)

(define-macro (stackerizer-mb EXPR)
  #'(#%module-begin
     (for-each displayln (reverse (flatten EXPR)))))
(provide (rename-out [stackerizer-mb #%module-begin]))

(define-macro (define-op OP)
  #'(define-macro-cases OP
      [(OP FIRST) #'FIRST]
      ;; We want the ellipsis to be in the resulting op macro, not the
      ;; define-op macro. To do this we escape them using the (... ...)
      ;; syntax.
      [(OP FIRST NEXT (... ...))
       #'(list 'OP FIRST (OP NEXT (... ...)))]))

;; A macro which defines an individual macro for each operator supplied.
(define-macro (define-ops OP ...)
  #'(begin
      (define-macro-cases OP
        [(OP FIRST) #'FIRST]
        [(OP FIRST NEXT (... ...))
         #'(list 'OP FIRST (OP NEXT (... ...)))])
      ...))

;;(define-op +)
;;(define-op *)
(define-ops + *)
