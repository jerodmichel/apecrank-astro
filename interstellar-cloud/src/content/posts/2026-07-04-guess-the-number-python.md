---
title: "'Guess the Number' Game in Python (CodeSkulptor)"
pubDatetime: 2013-05-15T00:00:00Z
author: "Jerod Michel"
featured: false
draft: false
tags: ["python", "simplegui", "codeskulptor", "guess the number", "game development", "code snippet"]
description: "A simple 'Guess the Number' game written in Python using the simplegui library for CodeSkulptor."
---

```python
import simplegui  
import random  
  
#define global variables  
message = "Guess the Number!"  
message1 = "Range: [0, 100]"  
code = 0  
counter = 0  
  
def init():  
  global code, counter  
  code = random.randrange(100)  
  counter = 7  
  frame.start()  
  print code  
  
  
# Handler for text input  
def guess(num):  
  global message, counter  
  cai = int(num)  
  counter -= 1  
  print counter  
  if (cai == code) and (counter > 0):  
    message = "Correct!"  
  elif (cai == code) and (counter <= 0):  
    message = "No more guesses!"  
  elif (cai != code) and (counter <= 0):  
    message = "No more guesses!"  
  else:  
    if cai > code:  
      message = "Lower!"  
    else:  
      message = "Higher!"  
      
# Handler for restart  
def ng_button():  
  init()  
      
      
  
# Handler to draw on canvas  
def draw(canvas):  
  canvas.draw_text(message, [25,112], 15, "white")  
  canvas.draw_text(message1, [25,40], 15, "red")  
  canvas.draw_circle((150, 150), 20, 15, "green")  
  if counter >= 0:  
    canvas.draw_text("You have" + " " + str(counter) + " " + "guesses left", [35, 60], 15, "blue")  
  else:  
    canvas.draw_text("You have" + " " + "0" + " " + "guesses left", [35, 60], 15, "blue")  
  
# Create a frame and assign callbacks to event handlers  
frame = simplegui.create_frame("Home", 300, 200)  
inp = frame.add_input("Guess:", guess, 100)  
restart = frame.add_button("New Game", ng_button)  
frame.set_draw_handler(draw)  
  
# Start the frame animation  
  
  
init()  
```