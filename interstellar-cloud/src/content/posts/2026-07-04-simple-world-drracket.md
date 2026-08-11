---
title: "Interactive Raindrop Simulation in Racket"
pubDatetime: 2013-05-15T00:00:00Z
author: "Jerod Michel"
featured: false
draft: false
tags: ["racket", "scheme", "htdp", "2htdp/universe", "simulation", "gui", "code snippet"]
description: "A small interactive simulation in Racket using the 2htdp/universe library that spawns falling raindrops on mouse clicks."
---

```lisp
(require 2htdp/image)
(require 2htdp/universe)  
  
  
  
;; =================  
;; Constants:  
  
(define WIDTH 300)  
(define HEIGHT 300)  
  
(define SPEED 1)  
  
(define DROP (ellipse 4 8 "solid" "blue"))  
  
(define MTS (rectangle WIDTH HEIGHT "solid" "light blue"))  
  
;; =================  
;; Data definitions:  
  
(define-struct drop (x y))  
;; Drop is (make-drop Integer Integer)  
;; interp. A raindrop on the screen, with x and y coordinates.  
  
(define D1 (make-drop 10 30))  
  
#;  
(define (fn-for-drop d)  
  (... (drop-x d)   
     (drop-y d)))  
  
;; Template Rules used:  
;; - compound: 2 fields  
  
  
;; ListOfDrop is one of:  
;; - empty  
;; - (cons Drop ListOfDrop)  
;; interp. a list of drops  
  
(define LOD1 empty)  
(define LOD2 (cons (make-drop 10 20) (cons (make-drop 3 6) empty)))  
  
#;  
(define (fn-for-lod lod)  
  (cond [(empty? lod) (...)]  
     [else  
      (... (fn-for-drop (first lod))  
        (fn-for-lod (rest lod)))]))  
  
;; Template Rules used:  
;; - one-of: 2 cases  
;; - atomic distinct: empty  
;; - compound: (cons Drop ListOfDrop)  
;; - reference: (first lod) is Drop  
;; - self reference: (rest lod) is ListOfDrop  
  
;; =================  
;; Functions:  
  
;; ListOfDrop -> ListOfDrop  
;; start rain program by evaluating (main empty)  
(define (main lod)  
  (big-bang lod  
       (on-mouse handle-mouse)  ; ListOfDrop Integer Integer MouseEvent -> ListOfDrop  
       (on-tick next-drops)   ; ListOfDrop -> ListOfDrop  
       (to-draw render-drops))) ; ListOfDrop -> Image  
  
  
;; ListOfDrop Integer Integer MouseEvent -> ListOfDrop  
;; if mevt is "button-down" add a new drop at that position  
;; !!!  
;(define (handle-mouse lod x y mevt) empty) ; stub  
  
(define (handle-mouse lod x y mevt)  
  (if (mouse=? mevt "button-down")  
    (cons (make-drop x y) lod)  
    lod))  
  
;; ListOfDrop -> ListOfDrop  
;; produce filtered and ticked list of drops  
;; !!!  
;(define (next-drops lod) empty) ; stub  
  
(define (next-drops lod)  
  (cond [(empty? lod) lod]  
     [else  
      (cons (make-drop (drop-x (first lod)) (+ (drop-y (first lod)) SPEED))  
      (next-drops (rest lod)))]))  
  
  
;; ListOfDrop -> Image  
;; Render the drops onto MTS  
;; !!!  
;(define (render-drops lod) MTS) ; stub  
  
(define (render-drops lod)  
  (cond [(empty? lod) MTS]  
     [else  
      (if (< (drop-y (first lod)) HEIGHT)  
        (place-image DROP (drop-x (first lod)) (drop-y (first lod))  
              (render-drops (rest lod)))  
        (render-drops (rest lod)))]))  
  
;(define (place-drop lod)  
; (cond [(empty? lod) lod]  
;    [else  
;     (... (fn-for-drop (first lod))  
;       (place-drop (rest lod)))]))  
  
(define (place-drop d)  
  (if (< (drop-y d) HEIGHT)  
    (place-image DROP (drop-x d) (drop-y d) MTS)  
    (...)))  
      
  
(main empty)  
```