#lang racket

(require 2htdp/universe 2htdp/image)

(define WIDTH 512)

(define locomotive-path
  (build-path (current-directory) "locomotive.png"))
(define LOCOMOTIVE (freeze (bitmap/file locomotive-path)))
(define LOCOMOTIVE-HEIGHT (image-height LOCOMOTIVE))
(define HEIGHT LOCOMOTIVE-HEIGHT)
(define LOCOMOTIVE-WIDTH (image-width LOCOMOTIVE))
(define LOCOMOTIVE-HEIGHT-HALF (quotient LOCOMOTIVE-HEIGHT 2))
(define LOCOMOTIVE-WIDTH-HALF (quotient LOCOMOTIVE-WIDTH 2))

(define BACKGROUND (empty-scene WIDTH HEIGHT))

(struct point (x y) #:transparent)

(define initial-state
  (point LOCOMOTIVE-WIDTH-HALF
         (- HEIGHT LOCOMOTIVE-HEIGHT-HALF)))

(define (draw-scene state)
  (place-image LOCOMOTIVE
               (point-x state)
               (point-y state)
               BACKGROUND))

(define (move-locomotive state)
  (if (= (point-x state) (+ WIDTH LOCOMOTIVE-WIDTH-HALF 1))
     (point (- LOCOMOTIVE-WIDTH-HALF)
            (point-y state))
     (point (add1 (point-x state))
            (point-y state))))

(big-bang initial-state
  (to-draw draw-scene)
  (on-tick move-locomotive))