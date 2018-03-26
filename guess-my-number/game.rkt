#lang racket
(require 2htdp/universe 2htdp/image)

(define UPPER-RANDOM-LIMIT 1000)
(define TEXT-SIZE 32)
(define HELP-TOP
  (text "'\u2191' for bigger numbers, '\u2193' for smaller ones" TEXT-SIZE "black"))
(define HELP-BOTTOM
  (text "Press '=' to confirm the number." TEXT-SIZE "black"))

(struct search (bottom top reduce-limit) #:transparent)

(define (guess search)
  (quotient (+ (search-bottom search) (search-top search)) 2))

(define (on-down-key-pressed state)
  (search (search-bottom state)
          (sub1 (guess state))
          #t))

(define (on-upper-key-pressed state)
  (if (search-reduce-limit state)
      (search (add1 (guess state))
              (search-top state)
              (search-reduce-limit state))
      (search (add1 (guess state))
              (* (search-top state) 2)
              (search-reduce-limit state))))

(define (on-equal-key-pressed state)
  (search (guess state)
          (guess state)
          #t))

(define (handle-key state key)
  (cond
    [(key=? key "up") (on-upper-key-pressed state)]
    [(key=? key "down") (on-down-key-pressed state)]
    [(key=? key "=") (on-equal-key-pressed state)]
    [else state]))

(define (guess-text n color)
  (text
   (string-append "The number is " (number->string n))
   (* TEXT-SIZE 2)
   color))

(define (create-world state)
  (define middle-point (guess state))
  (above/align "middle"
               HELP-TOP
               (if (is-final? state)
                   (guess-text middle-point "red")
                   (guess-text middle-point "blue"))
               HELP-BOTTOM))

(define initial-state (search 0 (random UPPER-RANDOM-LIMIT) #f))

(define (is-final? state)
  (= (search-bottom state) (search-top state)))

(define (start)
  (big-bang initial-state
    (to-draw create-world)
    (on-key handle-key)
    (stop-when is-final? create-world)))

(start)
