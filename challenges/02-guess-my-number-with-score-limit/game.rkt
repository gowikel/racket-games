#lang racket
(require 2htdp/universe 2htdp/image)

(define UPPER-RANDOM-LIMIT 1000)
(define TEXT-SIZE 32)
(define HELP-TOP
  (text "'\u2191' for bigger numbers, '\u2193' for smaller ones" TEXT-SIZE "black"))
(define HELP-BOTTOM
  (text "Press '=' to confirm the number." TEXT-SIZE "black"))

(struct meta (reduce-limit total-tries max-tries) #:transparent)
(struct search (bottom top meta) #:transparent)

(define (guess search)
  (quotient (+ (search-bottom search) (search-top search)) 2))

(define (optimistic-guesses bottom top)
  (define range (- top bottom))
  (if (> range 0)
      (add1 (ceiling (log range 2)))
      0))

(define (on-down-key-pressed state)
  (define bottom-limit (search-bottom state))
  (define top-limit (guess state))
  (search bottom-limit
          top-limit
          (meta #t
                (add1 (meta-total-tries (search-meta state)))
                    (optimistic-guesses bottom-limit
                                        top-limit))))
          
(define (on-upper-key-pressed state)
  (define bottom-limit (guess state))
  (define top-limit (if (meta-reduce-limit (search-meta state))
                        (search-top state)
                        (* (search-top state) 2)))
  (define current-tries (add1 (meta-total-tries (search-meta state))))
  (define next-guess (if (meta-reduce-limit (search-meta state))
                         (optimistic-guesses bottom-limit top-limit)
                         +inf.0))
  (search bottom-limit
          top-limit
          (meta (meta-reduce-limit (search-meta state))
                current-tries
                next-guess)))

(define (on-equal-key-pressed state)
  (search (guess state)
          (guess state)
          (search-meta state)))

(define (handle-key state key)
  (cond
    [(key=? key "up") (on-upper-key-pressed state)]
    [(key=? key "down") (on-down-key-pressed state)]
    [(key=? key "=") (on-equal-key-pressed state)]
    [else state]))

(define (current-tries-text n)
  (text (string-append "Current tries: "
                       (number->string n))
                       14
                       "black"))

(define (total-tries-text n)
  (text (string-append "The number will be found in "
                       (if (infinite? n)
                           "\u221e"
                           (number->string n))
                       " tries or less.")
        14
        "black"))

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
               HELP-BOTTOM
               (current-tries-text (meta-total-tries (search-meta state)))
               (total-tries-text (meta-max-tries (search-meta state)))))

(define initial-state (search 0
                              ;;(random UPPER-RANDOM-LIMIT)
                              571
                              (meta #f
                                    0
                                    +inf.0)))

(define (is-final? state)
  (= (search-bottom state) (search-top state)))

(define (start)
  (big-bang initial-state
    (to-draw create-world)
    (on-key handle-key)
    (stop-when is-final? create-world)))

(start)
