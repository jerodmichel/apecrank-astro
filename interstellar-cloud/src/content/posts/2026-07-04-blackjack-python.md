---
title: "Blackjack Game in Python (CodeSkulptor)"
pubDatetime: 2013-05-15T00:00:00Z
author: "Jerod Michel"
featured: false
draft: false
tags: ["python", "simplegui", "codeskulptor", "blackjack", "game development", "code snippet"]
description: "A complete Blackjack game written in Python using the simplegui library for CodeSkulptor."
---

![Blackjack Game Interface](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgFbq97MCRJWVdLAhkPmiEr5PmFApuR_Y-ImTfhmquQn1rLw86thK8aBuAiITQBDbAIQHTxx8rngtDj0lJdXf1K9w2zCS4NTIeRSulMSZoo0bUuKnDJ62Bfrqkw1YhDkW6iUEAQ7xF12U4/s1600/blackjacksnap.png)

```python
import simplegui  
import random  
  
# load card sprite - 949x392 - source: jfitz.com  
CARD_SIZE = (73, 98)  
CARD_CENTER = (36.5, 49)  
card_images = simplegui.load_image("[http://commondatastorage.googleapis.com/codeskulptor-assets/cards.jfitz.png](http://commondatastorage.googleapis.com/codeskulptor-assets/cards.jfitz.png)")  
  
CARD_BACK_SIZE = (71, 96)  
CARD_BACK_CENTER = (35.5, 48)  
card_back = simplegui.load_image("[http://commondatastorage.googleapis.com/codeskulptor-assets/card_back.png](http://commondatastorage.googleapis.com/codeskulptor-assets/card_back.png)")   
  
# initialize some useful global variables  
in_play = False  
message1 = ""  
wins = 0  
losses = 0  
  
# define globals for cards  
SUITS = ('C', 'S', 'H', 'D')  
RANKS = ('A', '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K')  
VALUES = {'A':1, '2':2, '3':3, '4':4, '5':5, '6':6, '7':7, '8':8, '9':9, 'T':10, 'J':10, 'Q':10, 'K':10}  
  
  
# define card class  
class Card:  
  def __init__(self, suit, rank):  
    if (suit in SUITS) and (rank in RANKS):  
      self.suit = suit  
      self.rank = rank  
    else:  
      self.suit = None  
      self.rank = None  
      print "Invalid card: ", suit, rank  
  
  def __str__(self):  
    return self.suit + self.rank  
  
  def get_suit(self):  
    return self.suit  
  
  def get_rank(self):  
    return self.rank  
  
  def draw(self, canvas, pos):  
    card_loc = (CARD_CENTER[0] + CARD_SIZE[0] * RANKS.index(self.rank),   
          CARD_CENTER[1] + CARD_SIZE[1] * SUITS.index(self.suit))  
    canvas.draw_image(card_images, card_loc, CARD_SIZE, [pos[0] + CARD_CENTER[0], pos[1] + CARD_CENTER[1]], CARD_SIZE)  
      
  def draw_back(self, canvas, pos):  
    card_loc = (CARD_BACK_CENTER[0], CARD_BACK_CENTER[1])  
    canvas.draw_image(card_back, card_loc, CARD_BACK_SIZE, [pos[0] + CARD_CENTER[0], pos[1] + CARD_BACK_CENTER[1]], CARD_BACK_SIZE)  
      
      
# define hand class  
class Hand:  
  def __init__(self):  
    self.cards = []  
    pass     # create Hand object  
  
  def __str__(self):  
    ans = " "  
    for i in range(len(self.cards)):  
      ans += str(self.cards[i]) + " "  
    return "Hand contains" + ans  
    pass     # return a string representation of a hand  
  
  def add_card(self, card):  
    self.cards.append(card)  
    pass     # add a card object to a hand  
      
  def get_value(self):  
    hand_value = 0  
    check = 0  
    for card in self.cards:  
      card_rank = card.get_rank()  
      hand_value += VALUES[card.get_rank()]  
      if card_rank == 'A':  
        check += 1  
      else:  
        pass  
    if check != 0:  
      if hand_value + 10 <= 21:  
        hand_value += 10  
      else:  
        pass  
        
    return hand_value  
        
    # count aces as 1, if the hand has an ace, then add 10 to hand value if it doesn't bust  
    pass     # compute the value of the hand, see Blackjack video   
  
    
  def draw(self, canvas, pos):  
                      
    for card in self.cards:  
      if pos == [100, 350]:  
        if in_play == True:   
          card.draw_back(canvas, pos)  
        else:  
          card.draw(canvas, pos)  
      else:  
        card.draw(canvas, pos)  
      
      pos[0] += 50  
  
    pass     # draw a hand on the canvas, use the draw method for cards  
    
      
# define deck class   
class Deck:  
  def __init__(self):  
    self.card = []  
    for suit in SUITS:  
      for rank in RANKS:  
        self.card.append(Card(suit, rank))  
    pass     # create a Deck object  
  
  def shuffle(self):  
    # add cards back to deck and shuffle  
    self.card_shuffled = random.shuffle(self.card)  
    pass     # use random.shuffle() to shuffle the deck  
  
  def deal_card(self):  
    return self.card.pop()  
    pass     # deal a card object from the deck  
      
  def __str__(self):  
    s = ""  
    for i in self.card:  
      s += str(i) + " "  
    return s  
    pass     # return a string representing the deck   
  
  
  
#define event handlers for buttons  
def deal():  
  global outcome, in_play, p_hand, d_hand, deck, message1, message2, wins, losses  
  message1 = "Hit, Stand, or New Deal?"  
  deck = Deck()  
  deck.shuffle()  
  p_hand = Hand()  
  d_hand = Hand()  
  p_hand.add_card(deck.deal_card())  
  p_hand.add_card(deck.deal_card())  
  d_hand.add_card(deck.deal_card())  
  d_hand.add_card(deck.deal_card())  
  if in_play == True:  
    message1 = "Dealer Won-Hit, Stand or New Deal?"  
    losses += 1  
  print "Player's", p_hand  
  print "Dealer's", d_hand  
  print message1  
  print wins - losses  
  
  # your code goes here  
    
  in_play = True  
  
def hit():  
  global message1, in_play, losses, wins  
  if in_play == True:  
    if p_hand.get_value() <= 21:   
      p_hand.add_card(deck.deal_card())  
    else:  
      message1 = "You bust-New Deal?"  
      in_play = False  
      losses += 1  
      print message1  
  print wins - losses  
  print "Player's", p_hand  
  print "Dealer's", d_hand  
  pass     # replace with your code below  
    
  # if the hand is in play, hit the player  
    
  # if busted, assign a message to outcome, update in_play and score  
      
def stand():  
  global message1, in_play, losses, wins  
  if in_play == True:  
    if p_hand.get_value() > 21:  
      message1 = "You bust-New Deal?"  
      in_play = False  
      losses += 1  
      print message1  
    else:   
      while d_hand.get_value() < 17:  
        d_hand.add_card(deck.deal_card())  
      if d_hand.get_value() > 21:  
        message1 = "Dealer Busts-New Deal?"  
        wins += 1  
        print message1  
      else:  
        if p_hand.get_value() <= d_hand.get_value():  
          message1 = "Dealer Wins-New Deal?"  
          losses += 1  
          print message1  
        else:  
          message1 = "You Win-New Deal?"  
          wins += 1  
          print message1  
      in_play = False   
  print "Player's", p_hand  
  print "Dealer's", d_hand  
  print wins - losses  
  pass     # replace with your code below  
    
  # if hand is in play, repeatedly hit dealer until his hand has value 17 or more  
  
  # assign a message to outcome, update in_play and score  
  
# draw handler   
def draw(canvas):  
  p_pos = [100, 50]  #player hand position      
  d_pos = [100, 350]             #dealer draw position  
  p_hand.draw(canvas, p_pos)  
  d_hand.draw(canvas, d_pos)  
    
  #if in_play == True:  
    #d_hand.draw(canvas, d_pos)      
  #else:  
    #d_hand.draw(canvas, d_pos)  
    
  canvas.draw_text(message1, [30, 300], 30, "black")  
  canvas.draw_text("Blackjack", [300, 50], 50, "red")  
  canvas.draw_text("Player", [100, 170], 30, "blue")  
  canvas.draw_text("Dealer", [100, 470], 30, "blue")  
  canvas.draw_text("Score:" + str(wins - losses), [400, 130], 30, "white")  
    
    
# initialization frame  
p_hand = Hand()  
d_hand = Hand()  
  
  
frame = simplegui.create_frame("Blackjack", 600, 600)  
frame.set_canvas_background("Green")  
  
  
#create buttons and canvas callback  
frame.add_button("Deal", deal, 200)  
frame.add_button("Hit", hit, 200)  
frame.add_button("Stand", stand, 200)  
frame.set_draw_handler(draw)  
  
# get things rolling  
frame.start()  
```