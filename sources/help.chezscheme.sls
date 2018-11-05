(library (help)
  (export help)
  (import (chezscheme)
          (edu indiana match))

  (define tspl-list (include "tspl4.ss"))
  (define csug-list (include "csug9.ss"))

  (define (nested-list->hashtable ls)
    (define ht (make-eq-hashtable))
    (for-each (lambda (x)
                (match x
                  [(,name ,path) (guard (symbol? name))
                   (hashtable-set! ht name path)]
                  [(,name1 ,name2 ,path) (guard (and (symbol? name1) (symbol? name2)))
                   (hashtable-set! ht name1 path)
                   (hashtable-set! ht name2 path)]
                  [,other (error 'nested-list->hashtable "invalid list" x)]))
              ls)
    ht)

  (define tspl-table (nested-list->hashtable tspl-list))
  (define csug-table (nested-list->hashtable csug-list))

  (define (find-path name)
    (let ([path (hashtable-ref tspl-table name "")])
      (if (string=? path "")
          (cons 'csug (hashtable-ref csug-table name ""))
          (cons 'tspl path))))

  (define (build-url path)
    (match path
      [(tspl . ,part)
       (if (string=? part "")
           (error 'help "help information not found, sorry")
           (string-append "https://www.scheme.com/tspl4/" part))]
      [(csug . ,part)
       (if (string=? part "")
           (error 'help "help information not found, sorry")
           (string-append "https://cisco.github.io/ChezScheme/csug9.5/" part))]
      [,other (error 'build-url "invalid path, (should not happen)" other)]))

  ;; Open url in default browser.
  (define (open-url url)
    (define (run cmd) (process cmd) (void))
    (case (machine-type)
      ;; Linux
      [(i3le ti3le a6le ta6le) (run (format "xdg-open ~a" url))]
      ;; macOS
      [(i3osx ti3osx a6osx ta6osx) (run (format "open ~a" url))]
      ;; Windows
      [(ta6nt a6nt i3nt ti3nt) (run (format "start ~a" url))]
      [else
       (if (zero? (system "which xdg-open >/dev/null 2>&1"))
           (run (format "xdg-open ~a" url))
           (error 'help "don't known how to open a url, sorry."))]))

  (define (help name)
    (define url (build-url (find-path name)))
    (open-url url))

  ) ; end of library
