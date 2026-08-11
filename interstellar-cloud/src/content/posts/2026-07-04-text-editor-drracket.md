---
title: "Simple Text Editor in Racket"
pubDatetime: 2013-05-15T00:00:00Z
author: "Jerod Michel"
featured: false
draft: false
tags: ["racket", "scheme", "htdp", "2htdp/universe", "gui", "code snippet"]
description: "An interactive command-line/GUI text editor implementation in Racket using the 2htdp/universe library."
---

```lisp
(require 2htdp/image)  
(require 2htdp/universe)  
  
;;
;;  
;;  
;;  
;; The screen looks like:  
;;   
;;   abc|def  
;;  
;; where | is the cursor.  
;;  
;; Typing a character inserts that character before the cursor.  
;; The backspace key deletes the character before the cursor.  
;; The left and right arrow keys move the cursor left and right.  
  
  
  
;; =================================================================================  
;; Constants:  
  
(define WIDTH 200)  
(define HEIGHT 20)  
  
(define TEXT-SIZE 18)  
(define TEXT-COLOR "BLACK")  
  
(define CURSOR (rectangle 1 20 "solid" "red"))  
  
(define MTS (empty-scene WIDTH HEIGHT))  
  
  
  
;; =================================================================================  
;; Data Definitions:  
  
(define-struct editor (txt cp))  
;; Editor is (make-editor String Natural)  
;; interp. the current text (txt) and cursor position (cp) using a 0-based index  
  
(define ED1 (make-editor ""    0)) ; empty  
(define ED2 (make-editor "abcdef" 0)) ; cursor at beginning as in |abcdef  
(define ED3 (make-editor "abcdef" 3)) ; cursor in middle of text as in abc|def  
(define ED4 (make-editor "abcdef" 6)) ; cursor at end as in abcdef|  
  
#;  
(define (fn-for-editor e)  
  (... (editor-txt e)  
     (editor-cp e)))  
  
;; =================================================================================  
;; Functions:  
  
;; Editor -> Editor  
;; start the world with an initial state e, for example (main (make-editor "" 0))  
(define (main e)  
 (big-bang e  
       (to-draw  render)         ; Editor -> Image  
       (on-key   handle-key)))      ; Editor KeyEvent -> Editor  
  
  
  
;; Editor -> Image  
;; place text with cursor at left, middle edge of MTS  
(check-expect (render (make-editor "abcdef" 3))  
        (overlay/align "left"  
                 "middle"  
                 (beside (text "abc" TEXT-SIZE TEXT-COLOR)  
                     CURSOR  
                     (text "def" TEXT-SIZE TEXT-COLOR))  
                 MTS))  
  
;(define (render e) MTS) ;stub  
  
(define (render e)  
 (overlay/align "left"  
          "middle"  
          (beside (text (substring (editor-txt e) 0 (editor-cp e)) TEXT-SIZE TEXT-COLOR)  
              CURSOR  
              (text (substring (editor-txt e) (editor-cp e) (string-length (editor-txt e))) TEXT-SIZE TEXT-COLOR))  
          MTS))  
  
  
  
;; Editor KeyEvent -> Editor  
;; call appropriate function for each keyboard command  
  
  
;(define (handle-key e key) e) ;stub  
(check-expect (curs-left ED1) ED1)  
(check-expect (curs-left ED2) ED2)  
(check-expect (curs-left ED3) (make-editor "abcdef" 2))  
(check-expect (curs-left ED4) (make-editor "abcdef" 5))  
  
(define (handle-key e key)  
 (cond [(key=? key "left")    (curs-left e)]  
       [(key=? key "right")    (curs-right e)]  
       [(key=? key "\b")     (take-out e)]      
       [(= (string-length key) 1) (write e key)]  
       [else (make-editor (editor-txt e) (editor-cp e))]))  
  
; Note:   
; "left" is the left arrow key, "right" is the right arrow key, and   
; "\b" is the backspace key.  
  
  
;; Editor -> Editor  
;; consumes editor and returns editor with cursor position decreased by one  
(check-expect (curs-left ED1) ED1)  
(check-expect (curs-left ED2) ED2)  
(check-expect (curs-left ED3) (make-editor "abcdef" 2))  
(check-expect (curs-left ED4) (make-editor "abcdef" 5))  
  
(define (curs-left e)  
 (if (> (editor-cp e) 0)  
    (make-editor (editor-txt e) (- (editor-cp e) 1))  
    (make-editor (editor-txt e) (editor-cp e))))  

;; Editor -> Editor  
;; consumes editor and returns editor with cursor position increased by one  
(check-expect (curs-right ED1) (make-editor "" 0))  
(check-expect (curs-right ED2) (make-editor "abcdef" 1))  
(check-expect (curs-right ED3) (make-editor "abcdef" 4))  
(check-expect (curs-right ED4) (make-editor "abcdef" 6))  
  
(define (curs-right e)  
 (if (< (editor-cp e) (string-length (editor-txt e)))  
      (make-editor (editor-txt e) (+ (editor-cp e) 1))  
      (make-editor (editor-txt e) (editor-cp e))))  
  
;; Editor -> Editor  
;; deletes one character from the editor, leaving cursor in place of deleted character  
(check-expect (take-out ED1) ED1)  
(check-expect (take-out ED2) ED2)  
(check-expect (take-out ED3) (make-editor "abdef" 2))  
(check-expect (take-out ED4) (make-editor "abcde" 5))  
  
(define (take-out e)  
 (make-editor (string-append (substring (editor-txt e) 0 (editor-cp (curs-left e)))    
                 (substring (editor-txt e) (editor-cp e))) (editor-cp (curs-left e))))  

;; Editor String -> Editor  
;; inserts characters corresponding to keys on keyboard into   
;; the editor and cursor position  
(check-expect (write ED3 "what?") (make-editor "abcwhat?def" 4))  
  
(define (write e s)  
 (make-editor (string-append (substring (editor-txt e)    
                         0 (editor-cp e))    
                         s (substring (editor-txt e) (editor-cp e)    
                         (string-length (editor-txt e))))    
                         (+ (editor-cp e) 1)))  
  
(main (make-editor "abcdef" 3))  
```