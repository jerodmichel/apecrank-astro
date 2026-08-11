---
title: "Memory Game in Python (CodeSkulptor)"
pubDatetime: 2013-05-15T00:00:00Z
author: "Jerod Michel"
featured: false
draft: false
tags: ["python", "simplegui", "codeskulptor", "memory", "game development", "code snippet"]
description: "A complete Memory puzzle game written in Python using the simplegui library for CodeSkulptor."
---

![Memory Game Interface](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEi98gtMAYBzHQvG7AJEKf5TEiX3gbYyKWWNleF1GYhpc44wc8fIJbB6N8anaMfwqM2TYO3NpU71DZkIwIp-5F9cCR8YwB1ZPZy94XFNNrqjnk7bny3w6vD5fLISFnNsFZNpCtH0tTvj_V0/s1600/memorysnap.png)

```python
import simplegui  
import random  
  
  
  
# helper function to initialize globals  
def init():  
  global lst1, lst2, deck, exposed, state, flipt1, flipt2, moves  
  moves = 0  
  flipt1 = -1  
  flipt2 = -2  
  state = 0  
  exposed = [False]*16  
  lst1 = range(8)  
  lst2 = range(8)  
  random.shuffle(lst1)  
  random.shuffle(lst2)  
  deck = lst1 + lst2  
  random.shuffle(deck)  
  pass   
  
    
# define event handlers  
def mouseclick(pos):  
  global moves, exposed, state, deck, flipt1, flipt2  
  a = 0  
  b = 0  
  # add game state logic here  
  moves += 1  
  num = pos[0] // 50  
  if exposed[num] == False:  
    if state == 0:  
      exposed[num] = True  
      state = 1  
      flipt1 = num  
        
    elif state == 1:  
      exposed[num] = True  
      state = 2  
      flipt2 = num  
        
    else:  
      state = 1  
      if deck[flipt1] != deck[flipt2]:  
        exposed[flipt1] = False  
        exposed[flipt2] = False  
      exposed[num] = True  
      flipt1 = num  
      flipt2 = -2  
        
    print num, exposed[num], state, flipt1, flipt2, moves  
  pass  
    
              
# cards are logically 50x100 pixels in size    
def draw(canvas):  
  spc = 0  
  x = 0  
  label.set_text("Moves =" + str(moves))  
  for crd in deck:  
    global exposed, state, flipt1, flipt2  
    if exposed[x] == True:  
      canvas.draw_text(str(crd), (spc, 80), 50, "white")  
        
    else:  
      canvas.draw_line((spc + 25, 0), (spc + 25, 100), 50, "Green")  
    
    x += 1  
    spc += 50  
    canvas.draw_polyline([(spc, 0), (spc, 100)], 2, "Red")  
  pass  
  
  
# create frame and add a button and labels  
frame = simplegui.create_frame("Memory", 800, 100)  
frame.add_button("Restart", init)  
label = frame.add_label("Moves = 0")  
  
# initialize global variables  
init()  
  
# register event handlers  
frame.set_mouseclick_handler(mouseclick)  
frame.set_draw_handler(draw)  
  
# get things rolling  
frame.start()  
```