#lang racket

(require web-server/servlet
         web-server/servlet-env
         net/url)

(define PUBLIC-DIR (build-path (current-directory) "public"))
(define PORT 3000)

(define (start req)
  (define path (url->string (request-uri req)))
  (define file
    (cond
      [(or (equal? path "/") (equal? path "")) 
       (build-path PUBLIC-DIR "index.html")]
      [else 
       (build-path PUBLIC-DIR (substring path 1))]))
  
  (if (file-exists? file)
      (response/full
        200 #"OK"
        (current-seconds)
        (string->bytes/utf-8 "text/html")
        '()
        (list (file->bytes file)))
      (response/xexpr '(html (body (p "404 - Not Found"))))))

(printf "SERVIDOR LIGADO http://localhost:~a~n" PORT)
(printf "PEGANDO DADOS DE: ~a~n" PUBLIC-DIR)

(serve/servlet
  start
  #:port PORT
  #:launch-browser? #f
  #:servlet-path "/"
  #:extra-files-paths (list PUBLIC-DIR))