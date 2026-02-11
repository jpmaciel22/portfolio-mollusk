#lang racket
(require xml)

(define template-path-str (vector-ref (current-command-line-arguments) 0))
(define data-path-str (vector-ref (current-command-line-arguments) 1))

(define (read-rktd-hash path)
  (with-input-from-file path read))

;; 1. Tenta carregar o default.rktd
(define default-path (build-path (current-directory) "data" "default.rktd"))
(define default-data
  (if (file-exists? default-path)
      (read-rktd-hash default-path)
      (hash)))

;; 2. Tenta carregar o .rktd específico do template
(define template-data
  (if (file-exists? data-path-str)
      (read-rktd-hash data-path-str)
      (hash)))

;; 3. Junta os dois: primeiro default, depois template (template sobrescreve)
(define env
  (for/fold ([result default-data])
            ([(key val) (in-hash template-data)])
    (hash-set result key val)))

(define template-path (path->complete-path (string->path template-path-str)))
(define render-fn (dynamic-require template-path 'render))
(define xexprs (render-fn env))

(define html-body (string-append* (map xexpr->string xexprs)))

(define html-full
  (string-append
   "<!doctype html>\n<html lang=\"pt-br\" data-theme=\"dark\">\n<head>\n"
   "  <meta charset=\"utf-8\" />\n"
   "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\" />\n"
   "  <title>Portfólio</title>\n"
   "    <link rel=\"stylesheet\" href=\"style.css\">"
   "</head>\n<body>\n"
   html-body
   "\n</body>\n</html>\n"))

(display html-full)
