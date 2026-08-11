---
title: "Cubic Spline Interpolation in Sage"
pubDatetime: 2011-03-05T00:00:00Z
author: "Jerod Michel"
featured: false
draft: false
tags: ["sage", "sagemath", "math", "interpolation", "cubic-spline", "numpy", "code snippet"]
description: "A demonstration of how to write and plot a natural cubic spline interpolation algorithm using Numpy and SageMath."
---

A spline is an interpolating function. When data has a cubic shape (i.e. when plotted resembles the graph of a cubic polynomial) one can try to model the data using a *cubic spline*. A natural cubic spline must have a knot at every point and if $x$ is an endpoint, then $f''(x) = 0$. The following shows how to find a cubic spline in Sage with the five points given by: X = (0, 1.5, 3, 4.5, 6), Y = (1, 4, .5, 0, 3.5).

```python
import numpy as np  
  
# Array Array Array -> Array Array Array  
# interp. helper function whose input is three parameters (from data_curvtr function) and output is three parameters  
# to give to the first3solv function  
  
def first3(c,d,e):  
  n = d.shape[0]  
  for i in xrange(1,n):  
    kappa = c[i-1]/d[i-1]  
    d[i] = d[i] - kappa*e[i-1]  
    c[i-1] = kappa  
  return c,d,e  
  
# Array Array Array Array -> Array  
# interp. helper function whose input is four arrays (three from the first3 function, and one from the data_curvtr  # function) whose output is a single array  
  
def first3solv(c,d,e,b):  
  n = d.shape[0]  
  for i in xrange(1,n):  
    b[i] = b[i] - c[i-1]*b[i-1]  
  
  b[n-1] = b[n-1]/d[n-1]  
  for i in xrange(n-2,-1,-1):  
    b[i] = (b[i] - e[i]*b[i+1])/d[i]  
  
  return b  
  
# Array Array -> Array  
# interp. consumes a list of x-values and a list of y-values and returns the curvatures to be used in the cubic spline  
# algorithm  
      
def data_curvtr(xArray,yArray):  
  n = len(xArray) - 1  
  c = np.zeros(n)  
  d = np.ones(n+1)  
  e = np.zeros(n)  
  k = np.zeros(n+1)  
  c[0:n-1]= xArray[0:n-1] - xArray[1:n]  
  d[1:n] = 2.0*(xArray[0:n-1] - xArray[2:n+1])  
  e[1:n] = xArray[1:n] - xArray[2:n+1]  
  k[1:n] = 6.0*(yArray[0:n-1] - yArray[1:n]) \  
    /(xArray[0:n-1] - xArray[1:n]) \  
    -6.0*(yArray[1:n] - yArray[2:n+1]) \  
    /(xArray[1:n] - xArray[2:n+1])  
  first3(c,d,e)  
  print "c =",c,"d =",d,"e =",e  
  first3solv(c,d,e,k)  
  return k  
  
# Array Array Array Number -> Number  
# interp. consumes the data lists, the curvatures, and an x-value, and carries out the cubic spline algorithm   
# to produce the height of the spline at the x-value  
  
def get_spline(xArray,yArray,k,x):  
  def get_segment(xArray,x):  
    i_left = 0  
    i_right = len(xArray)- 1  
    while 1:  
      if (i_right-i_left)<=1: return i_left  
      i=(i_left+i_right)//2  
      if x < xArray[i]: i_right=i  
      else: i_left=i  
  i=get_segment(xArray,x)  
  h = xArray[i]-xArray[i+1]   
  y = ((x-xArray[i+1])**3/h-(x-xArray[i+1])*h)*k[i]/6.0 \  
    - ((x-xArray[i])**3/h-(x-xArray[i])*h)*k[i+1]/6.0 \  
    + (yArray[i]*(x-xArray[i+1])            \  
    - yArray[i+1]*(x-xArray[i]))/h  
  return y   
  
xA1=np.array([0.,1.5,3.,4.5,6.])  
yA1=np.array([1.,4.,.5,0.,3.5])  
print "X =",xA1,"Y =",yA1   
  
k= data_curvtr(xA1,yA1)  
print "k =",k  
  
y= get_spline(xA1,yA1,k,.5)  
print "y =",y  
  
var ( 'x t' )  
n=len(xA1)  
P=list_plot(zip(xA1,yA1), color="green", size=30)  
C=sum(point((t,get_spline(xA1,yA1,k,t))) for t in [xA1[0]..xA1[n-1], step=0.1])  
show(P+C)  
```

In the above code I have found a cubic spline for the following five points: X = (0, 1.5, 3, 4.5, 6), Y = (1, 4, .5, 0, 3.5) (one can see these entered in lines 73 and 74 above). When run in sage you get:

```text
 X = [ 0.  1.5 3.  4.5 6. ] Y = [ 1.  4.  0.5 0.  3.5]  
 c = [-1.5      0.25    0.26666667 -0.    ] d = [ 1.  -6.  -5.625 -5.6  1.  ] e = [ 0. -1.5 -1.5 -1.5]  
 k = [ 0.     -5.02380952 2.76190476 1.97619048 0.    ]  
 y = 2.5582010582  
```

![Sage Spline Output](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhJwjbxe2SwDGYTxUHFOAC540Y7dlmuAXTVuNOi-2dcOttFa8DjhSIG5MMmoAAreNs0zTTDp55Vk2Niy4wqOvvuX5_arWTPewkht7fL-XhqitvVnkZj65NtTTIdPBoVS6OLEAH0PLQVXKY/s1600/sage_spline.png)