#!/usr/bin/env scheme --script

(define (system* cmd)
  (display cmd) (newline)
  (unless (zero? (system cmd))
    (error #f "run command failed" cmd)))

(define (install pair)
  (let ([source-target (car pair)]
        [compiled-target (cdr pair)])
    (current-directory "./sources")
    (compile-library "help.chezscheme.sls")
    #;(system* (format "cp -f ~a ~a" "help.chezscheme.sls" source-target))
    (system* (format "cp -f ~a ~a" "help.chezscheme.so"  compiled-target))))

(define libdirs
  (remove '("." . ".") (library-directories)))

(if (null? libdirs)
    (error #f "no target found, library-directories is null")
    (install (car libdirs)))

(printf "\nDone.\n")
