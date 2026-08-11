---
title: "Asteroids Game in Python (CodeSkulptor)"
pubDatetime: 2013-05-15T00:00:00Z
author: "Jerod Michel"
featured: false
draft: false
tags: ["python", "simplegui", "codeskulptor", "asteroids", "game development", "code snippet"]
description: "A complete Asteroids clone written in Python using the simplegui library for CodeSkulptor."
---

![Asteroids Game Interface 1](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgIqQKdlxR8jmF1j8H-bg3Dnr4duKS9oSlrjyeremKQ8ItPVeevK6pD7sqmgoeXonKZRsHBmIwCrHZwL2uOgazSSo3u3McIJQmR_UpbKJAkX42-31FggbdVPUWh_f6hk1ePGZtSwPCpUos/s1600/asteroidsnap1.png)

![Asteroids Game Interface 2](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgrhgYpXsXT8_qAPW6qsQy1mnikYGOJutDo9tjDmwDnXzL3c7f9DJa-Wu2AW70j0XBS0Rv0ERn7ODLbXG8le_QemFuHGRvpBM8Cl6z5ES_T5AVu5loCTuavBH36PrI_dnEaZyYfHysF600/s1600/asteroidsnap.png)

```python
import simplegui  
import math  
import random  
  
# globals for user interface  
WIDTH = 800  
HEIGHT = 600  
score = 0  
lives = 3  
time = 0.5  
started = False  
rock_group = set()  
missile_group = set()  
explosion_group = set()  
collisions = 0  
n_collisions = 0  
r_collisions = 0  
  
class ImageInfo:  
  def __init__(self, center, size, radius = 0, lifespan = None, animated = False):  
    self.center = center  
    self.size = size  
    self.radius = radius  
    if lifespan:  
      self.lifespan = lifespan  
    else:  
      self.lifespan = float('inf')  
    self.animated = animated  
  
  def get_center(self):  
    return self.center  
  
  def get_size(self):  
    return self.size  
  
  def get_radius(self):  
    return self.radius  
  
  def get_lifespan(self):  
    return self.lifespan  
  
  def get_animated(self):  
    return self.animated  
  
      
# art assets created by Kim Lathrop, may be freely re-used in non-commercial projects, please credit Kim  
      
# debris images - debris1_brown.png, debris2_brown.png, debris3_brown.png, debris4_brown.png  
#         debris1_blue.png, debris2_blue.png, debris3_blue.png, debris4_blue.png, debris_blend.png  
debris_info = ImageInfo([320, 240], [640, 480])  
debris_image = simplegui.load_image("[http://commondatastorage.googleapis.com/codeskulptor-assets/lathrop/debris2_blue.png](http://commondatastorage.googleapis.com/codeskulptor-assets/lathrop/debris2_blue.png)")  
  
# nebula images - nebula_brown.png, nebula_blue.png  
nebula_info = ImageInfo([400, 300], [800, 600])  
nebula_image = simplegui.load_image("[http://commondatastorage.googleapis.com/codeskulptor-assets/lathrop/nebula_blue.png](http://commondatastorage.googleapis.com/codeskulptor-assets/lathrop/nebula_blue.png)")  
  
# splash image  
splash_info = ImageInfo([200, 150], [400, 300])  
splash_image = simplegui.load_image("[http://commondatastorage.googleapis.com/codeskulptor-assets/lathrop/splash.png](http://commondatastorage.googleapis.com/codeskulptor-assets/lathrop/splash.png)")  
  
# ship image  
ship_info = ImageInfo([45, 45], [90, 90], 35)  
ship_image = simplegui.load_image("[http://commondatastorage.googleapis.com/codeskulptor-assets/lathrop/double_ship.png](http://commondatastorage.googleapis.com/codeskulptor-assets/lathrop/double_ship.png)")  
  
# missile image - shot1.png, shot2.png, shot3.png  
missile_info = ImageInfo([5,5], [10, 10], 3, 50)  
missile_image = simplegui.load_image("[http://commondatastorage.googleapis.com/codeskulptor-assets/lathrop/shot2.png](http://commondatastorage.googleapis.com/codeskulptor-assets/lathrop/shot2.png)")  
  
# asteroid images - asteroid_blue.png, asteroid_brown.png, asteroid_blend.png  
asteroid_info = ImageInfo([45, 45], [90, 90], 40)  
asteroid_image = simplegui.load_image("[http://commondatastorage.googleapis.com/codeskulptor-assets/lathrop/asteroid_blue.png](http://commondatastorage.googleapis.com/codeskulptor-assets/lathrop/asteroid_blue.png)")  
  
# animated explosion - explosion_orange.png, explosion_blue.png, explosion_blue2.png, explosion_alpha.png  
explosion_info = ImageInfo([64, 64], [128, 128], 17, 24, True)  
explosion_image = simplegui.load_image("[http://commondatastorage.googleapis.com/codeskulptor-assets/lathrop/explosion_alpha.png](http://commondatastorage.googleapis.com/codeskulptor-assets/lathrop/explosion_alpha.png)")  
  
# sound assets purchased from sounddogs.com, please do not redistribute  
# .ogg versions of sounds are also available, just replace .mp3 by .ogg  
soundtrack = simplegui.load_sound("[http://commondatastorage.googleapis.com/codeskulptor-assets/sounddogs/soundtrack.ogg](http://commondatastorage.googleapis.com/codeskulptor-assets/sounddogs/soundtrack.ogg)")  
missile_sound = simplegui.load_sound("[http://commondatastorage.googleapis.com/codeskulptor-assets/sounddogs/missile.ogg](http://commondatastorage.googleapis.com/codeskulptor-assets/sounddogs/missile.ogg)")  
missile_sound.set_volume(.5)  
ship_thrust_sound = simplegui.load_sound("[http://commondatastorage.googleapis.com/codeskulptor-assets/sounddogs/thrust.ogg](http://commondatastorage.googleapis.com/codeskulptor-assets/sounddogs/thrust.ogg)")  
explosion_sound = simplegui.load_sound("[http://commondatastorage.googleapis.com/codeskulptor-assets/sounddogs/explosion.ogg](http://commondatastorage.googleapis.com/codeskulptor-assets/sounddogs/explosion.ogg)")  
  
# helper functions to handle transformations  
def angle_to_vector(ang):  
  return [math.cos(ang), math.sin(ang)]  
  
def dist(p, q):  
  return math.sqrt((p[0] - q[0]) ** 2 + (p[1] - q[1]) ** 2)  
  
  
# Ship class  
class Ship:  
  
  def __init__(self, pos, vel, angle, image, info):  
    self.pos = [pos[0], pos[1]]  
    self.vel = [vel[0], vel[1]]  
    self.thrust = False  
    self.angle = angle  
    self.angle_vel = 0  
    self.image = image  
    self.image_center = info.get_center()  
    self.image_size = info.get_size()  
    self.radius = info.get_radius()  
      
  def draw(self,canvas):  
    if self.thrust:  
      canvas.draw_image(self.image, [self.image_center[0] + self.image_size[0], self.image_center[1]] , self.image_size,  
               self.pos, self.image_size, self.angle)  
    else:  
      canvas.draw_image(self.image, self.image_center, self.image_size,  
               self.pos, self.image_size, self.angle)  
    # canvas.draw_circle(self.pos, self.radius, 1, "White", "White")  
  
  def update(self):  
    # update angle  
    self.angle += self.angle_vel  
      
    # update position  
    self.pos[0] = (self.pos[0] + self.vel[0]) % WIDTH  
    self.pos[1] = (self.pos[1] + self.vel[1]) % HEIGHT  
  
    # update velocity  
    if self.thrust:  
      acc = angle_to_vector(self.angle)  
      self.vel[0] += acc[0] * .5  
      self.vel[1] += acc[1] * .5  
        
    self.vel[0] *= .95  
    self.vel[1] *= .95  
  
  def set_thrust(self, on):  
    self.thrust = on  
    if on:  
      ship_thrust_sound.rewind()  
      ship_thrust_sound.play()  
    else:  
      ship_thrust_sound.pause()  
        
  def increment_angle_vel(self):  
    self.angle_vel += .05  
      
  def decrement_angle_vel(self):  
    self.angle_vel -= .05  
      
  def shoot(self):  
    global a_missile  
    forward = angle_to_vector(self.angle)  
    missile_pos = [self.pos[0] + self.radius * forward[0], self.pos[1] + self.radius * forward[1]]  
    missile_vel = [self.vel[0] + 6 * forward[0], self.vel[1] + 6 * forward[1]]  
    a_missile = Sprite(missile_pos, missile_vel, self.angle, 0, missile_image, missile_info, missile_sound)  
    missile_group.add(a_missile)  
      
      
      
# Sprite class  
class Sprite:  
  def __init__(self, pos, vel, ang, ang_vel, image, info, sound = None):  
    self.pos = [pos[0],pos[1]]  
    self.vel = [vel[0],vel[1]]  
    self.angle = ang  
    self.angle_vel = ang_vel  
    self.image = image  
    self.image_center = info.get_center()  
    self.image_size = info.get_size()  
    self.radius = info.get_radius()  
    self.lifespan = info.get_lifespan()  
    self.animated = info.get_animated()  
    self.age = 0  
    if sound:  
      sound.rewind()  
      sound.play()  
      
  def draw(self, canvas):  
    if self.animated == True:  
      center = [self.image_center[0] + 2*self.image_center[0]*self.age, self.image_center[1]]  
      canvas.draw_image(self.image, center, self.image_size,  
             self.pos, self.image_size, self.angle)  
    else:  
      canvas.draw_image(self.image, self.image_center, self.image_size,  
             self.pos, self.image_size, self.angle)  
  
  def update(self):  
    # update angle  
    self.angle += self.angle_vel  
      
    # update position  
    self.pos[0] = (self.pos[0] + self.vel[0]) % WIDTH  
    self.pos[1] = (self.pos[1] + self.vel[1]) % HEIGHT  
    self.age += 1  
    if self.age >= self.lifespan:  
      return True  
    else:  
      return False  
      
  def collide(self, other_object):  
    if dist(self.pos, other_object.pos) > self.radius + other_object.radius:  
      return False  
    else:  
      return True  
        
   
      
# key handlers to control ship    
def keydown(key):  
  if key == simplegui.KEY_MAP['left']:  
    my_ship.decrement_angle_vel()  
  elif key == simplegui.KEY_MAP['right']:  
    my_ship.increment_angle_vel()  
  elif key == simplegui.KEY_MAP['up']:  
    my_ship.set_thrust(True)  
  elif key == simplegui.KEY_MAP['space']:  
    my_ship.shoot()  
      
def keyup(key):  
  if key == simplegui.KEY_MAP['left']:  
    my_ship.increment_angle_vel()  
  elif key == simplegui.KEY_MAP['right']:  
    my_ship.decrement_angle_vel()  
  elif key == simplegui.KEY_MAP['up']:  
    my_ship.set_thrust(False)  
      
# mouseclick handlers that reset UI and conditions whether splash image is drawn  
def click(pos):  
  global started, lives, score  
  center = [WIDTH / 2, HEIGHT / 2]  
  size = splash_info.get_size()  
  inwidth = (center[0] - size[0] / 2) < pos[0] < (center[0] + size[0] / 2)  
  inheight = (center[1] - size[1] / 2) < pos[1] < (center[1] + size[1] / 2)  
  if (not started) and inwidth and inheight:  
    started = True  
    lives = 3  
    score = 0  
    soundtrack.play()  
  
def draw(canvas):  
  global time, started, lives, score, rock_group  
    
  # animiate background  
  time += 1  
  center = debris_info.get_center()  
  size = debris_info.get_size()  
  wtime = (time / 8) % center[0]  
  canvas.draw_image(nebula_image, nebula_info.get_center(), nebula_info.get_size(), [WIDTH / 2, HEIGHT / 2], [WIDTH, HEIGHT])  
  canvas.draw_image(debris_image, [center[0] - wtime, center[1]], [size[0] - 2 * wtime, size[1]],   
              [WIDTH / 2 + 1.25 * wtime, HEIGHT / 2], [WIDTH - 2.5 * wtime, HEIGHT])  
  canvas.draw_image(debris_image, [size[0] - wtime, center[1]], [2 * wtime, size[1]],   
              [1.25 * wtime, HEIGHT / 2], [2.5 * wtime, HEIGHT])  
  
  if group_collide(rock_group, my_ship) > 0:  
    lives -= 1  
      
  if group_group_collide(rock_group, missile_group) > 0:  
    score += 1  
      
  if lives == 0:  
    started = False  
    rock_group = set()  
    soundtrack.rewind()  
    lives = 3  
      
  # draw UI  
  canvas.draw_text("Lives", [50, 50], 22, "White")  
  canvas.draw_text("Score", [680, 50], 22, "White")  
  canvas.draw_text(str(lives), [50, 80], 22, "White")  
  canvas.draw_text(str(score), [680, 80], 22, "White")  
  
  # draw ship and sprites  
  my_ship.draw(canvas)  
    
  process_sprite_group(rock_group, canvas)  
  process_sprite_group(missile_group, canvas)  
  process_sprite_group(explosion_group, canvas)  
    
      
  for a_missile in set(missile_group):  
    if a_missile.age >= a_missile.lifespan:  
      missile_group.remove(a_missile)  
    else:  
      pass  
    a_missile.draw(canvas)  
    a_missile.update()  
    
  # update ship and sprites  
  my_ship.update()  
  
  # draw splash screen if not started  
  if not started:  
    canvas.draw_image(splash_image, splash_info.get_center(),   
             splash_info.get_size(), [WIDTH / 2, HEIGHT / 2],   
             splash_info.get_size())  
  
# timer handler that spawns a rock    
def rock_spawner():  
  global a_rock, rock_group, score  
  if started:  
    if len(rock_group) < 12:  
      rock_pos = [random.randrange(0, WIDTH), random.randrange(0, HEIGHT)]  
      rock_vel = [random.random() * .6 - .3, random.random() * .6 - .3]  
      rock_avel = random.random() * .2 - .1  
      if score > 10:  
        rock_vel[0] *= 4  
        rock_vel[1] *= 4  
      elif score > 20:  
        rock_vel[0] *= 6  
        rock_vel[1] *= 6  
      elif score > 30:  
        rock_vel[0] *= 10  
        rock_vel[1] *= 10  
      elif score > 40:  
        rock_vel[0] *= 20  
        rock_vel[1] *= 20  
          
      a_rock = Sprite(rock_pos, rock_vel, 0, rock_avel, asteroid_image, asteroid_info)  
      if dist(my_ship.pos, rock_pos) > 3*my_ship.radius:  
        rock_group.add(a_rock)  
      else:  
        pass  
    else:  
      pass  
    
def process_sprite_group(group, canvas):  
  global collisions, lives  
    
  for sprite in set(group):  
    sprite.draw(canvas)  
    if sprite.update() == True:  
      group.remove(sprite)  
    else:  
      pass  
      
    sprite.update()  
  
def group_collide(group, sprite):  
  global collisions, explosion_group  
  for item in set(group):  
    if item.collide(sprite) == True:  
      group.remove(item)  
      exp = Sprite(item.pos, [0, 0], 0, 0, explosion_image, explosion_info, explosion_sound)  
      explosion_group.add(exp)  
      collisions += 1  
      return collisions  
    else:  
      pass  
     
      
def group_group_collide(group1, group2):  
  global n_collisions, r_collisions  
  for item1 in set(group1):  
    if group_collide(group2, item1) > 0:  
      r_collisions += 1  
      group1.remove(item1)  
      return r_collisions  
    else:  
      pass  
        
  
        
# initialize stuff  
frame = simplegui.create_frame("Asteroids", WIDTH, HEIGHT)  
  
# initialize ship and two sprites  
my_ship = Ship([WIDTH / 2, HEIGHT / 2], [0, 0], 0, ship_image, ship_info)  
  
#a_rock = Sprite([WIDTH / 3, HEIGHT / 3], [1, 1], 0, .1, asteroid_image, asteroid_info)  
#a_missile = Sprite([2 * WIDTH / 3, 2 * HEIGHT / 3], [-1,1], 0, 0, missile_image, missile_info, missile_sound)  
  
  
# register handlers  
frame.set_keyup_handler(keyup)  
frame.set_keydown_handler(keydown)  
frame.set_mouseclick_handler(click)  
frame.set_draw_handler(draw)  
  
timer = simplegui.create_timer(1000.0, rock_spawner)  
  
# get things rolling  
timer.start()  
frame.start()  
```