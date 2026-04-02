#lang racket

(require racket/system
         racket/path)

(define CWD (current-directory))
(define TEMPLATES-DIR (build-path CWD "templates"))
(define DATA-DIR (build-path CWD "data"))
(define OUTPUT-DIR (build-path CWD "public"))

(define (find-templates dir)
  (for/list ([file (in-directory dir)]
             #:when (equal? (path-get-extension file) #".rkt"))
    file))

(define (render-template template-path)
  (define relative-path (find-relative-path TEMPLATES-DIR template-path))
  (define template-name (path-replace-extension (file-name-from-path relative-path) #""))
  (define template-dir (let ([d (path-only relative-path)]) (or d (build-path "."))))

  (define data-path (build-path DATA-DIR template-dir (path-replace-extension template-name #".rktd")))
  (define data-arg (if (file-exists? data-path) data-path (build-path CWD "empty.rktd")))

  (printf "Rendering: ~a~n" relative-path)
  (printf "  Template: ~a~n" template-path)
  (printf "  Data: ~a~n" data-arg)

  (define html (with-output-to-string
                 (lambda ()
                   (system (format "racket render.rkt \"~a\" \"~a\"" template-path data-arg)))))

  (define output-path (build-path OUTPUT-DIR template-dir (path-replace-extension template-name #".html")))
  (make-directory* (path-only output-path))
  (display-to-file html output-path #:exists 'replace)

  (printf "  Output: ~a~n~n" output-path))

(define (build-all)
  (printf "Finding templates...~n~n")
  (define templates (find-templates TEMPLATES-DIR))
  (printf "Found ~a template(s)~n~n" (length templates))

  (for ([template templates])
    (with-handlers ([exn:fail? (lambda (e)
                                 (printf "Error rendering ~a: ~a~n" template (exn-message e)))])
      (render-template template)))

  (printf "Build complete!~n"))

(build-all)