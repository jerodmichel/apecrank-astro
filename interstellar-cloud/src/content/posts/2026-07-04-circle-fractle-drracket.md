---
title: "Circle Fractal in Racket"
pubDatetime: 2013-05-15T00:00:00Z
author: "Jerod Michel"
featured: false
draft: false
tags: ["racket", "scheme", "lisp", "fractals", "htdp", "code snippet"]
description: "A small Racket/Scheme script using the 2htdp/image library to recursively generate a simple circle fractal."
---

![Circle Fractal](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiXOwTU62L40xfdkpvSK3ttn1grHNAy303cUynGM3RX-zu3JKDD8sO0NTLY_w8qUZLAyrz3TmakRJHjj7hH0B9MPkZAJZK6JvZdeweS9DSGzM3ARj8nIbxfRL7dKHknt2BBkvvYUEUP4wA/s1600/fractal.png)

```lisp
(require 2htdp/image)  
  
  
;; =================  
;; Constants:  
  
(define STEP (/ 2 5))  
(define TRIVIAL-SIZE 5)  
  
;; Funtions  
  
;; Number -> Image  
;; produce the above fractal of the given size  
(check-expect (circle_frac TRIVIAL-SIZE) (circle 5 "solid" "darkgreen"))  
(check-expect (circle_frac (* (/ 5 2) TRIVIAL-SIZE))  
         (local [(define sub (circle 5 "solid" "darkgreen"))]  
          (above sub  
              (beside sub (circle (* (/ 5 2) TRIVIAL-SIZE) "solid" "darkgreen") sub)  
              sub)))  
  
  
;(define (circle_frac s)      ;stub  
; (square 0 "solid" "white"))  
  
(define (circle_frac s)  
 (if (<= s TRIVIAL-SIZE)  
   (circle s "solid" "darkgreen")  
   (local [(define sub (circle_frac (* STEP s)))]  
    (above sub  
        (beside sub (circle s "solid" "darkgreen") sub)  
        sub))))  
```