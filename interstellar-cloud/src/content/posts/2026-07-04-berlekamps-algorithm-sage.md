---
title: "Factoring Polynomials with Berlekamp's Algorithm in Sage"
pubDatetime: 2011-03-05T00:00:00Z
author: "Jerod Michel"
featured: false
draft: false
tags: ["sage", "sagemath", "math", "polynomials", "berlekamps-algorithm", "finite-fields", "code snippet"]
description: "A quick demonstration of how to factor a polynomial over a finite field using Berlekamp's algorithm in Sage."
---

We want to factor $f(x)=x^8+x^6+x^4+x^3+1$ over $\mathbb{F}_{2}$ using Berlekamp's algorithm. You can check up on the algorithm [here](http://www.johnkerl.org/doc/iw2009/berlekamp.pdf). It is easy to see that $f'(x) = x^2$ does not divide $f(x)$, but one can check this using the euclidean algorithm. In sage one checks this as follows:

```python
S.<x> = PolynomialRing(GF(2),'x')  
f = x**8 + x**6 + x**4 + x**3 + 1; g = x**2
f.gcd(g)  
```

which will result in $1$ when it is run. Next we compute $x^{iq} \pmod{f(x)}$ for $q=2,\ 0 \le i \le 7$. By using the Euclidean algorithm we get:

$$
\begin{aligned}
x^0 &\equiv 1 \\
x^2 &\equiv x^2 \\
x^4 &\equiv x^{4} \\
x^6 &\equiv x^{6} \\
x^8 &\equiv 1+x^3+x^4+x^6 \\
x^{10} &\equiv 1+x^2+x^4+x^5+x^6+x^7 \\
x^{12} &\equiv x^2+x^4+x^5+x^6+x^7 \\
x^{14} &\equiv 1+x+x^3+x^4+x^5
\end{aligned}
$$

This gives us the matrix:

```python
[1 0 0 0 0 0 0 0]  
[0 0 1 0 0 0 0 0]  
[0 0 0 0 1 0 0 0]  
[0 0 0 0 0 0 1 0]  
[1 0 0 1 1 0 1 0]  
[1 0 1 1 1 1 0 0]  
[0 0 1 0 1 1 1 1]  
[1 1 0 1 1 1 0 0]  
```

Then, subtracting the identity matrix we get:

```python
[0 0 0 0 0 0 0 0]  
[0 1 1 0 0 0 0 0]  
[0 0 1 0 1 0 0 0]  
[0 0 0 1 0 0 1 0]  
[1 0 0 1 0 0 1 0]  
[1 0 1 1 1 0 0 0]  
[0 0 1 0 1 1 0 1]  
[1 1 0 1 1 1 0 1]  
```

We now use sage to find the basis of the null space of the above matrix as follows:

```python
M = MatrixSpace(GF(2), 8, 8)  
A = M([0, 0, 0, 0, 0, 0, 0, 0,   
       0, 1, 1, 0, 0, 0, 0, 0,  
       0, 0, 1, 0, 1, 0, 0, 0,  
       0, 0, 0, 1, 0, 0, 1, 0,  
       1, 0, 0, 1, 0, 0, 1, 0,  
       1, 0, 1, 1, 1, 0, 0, 0,  
       0, 0, 1, 0, 1, 1, 0, 1,  
       1, 1, 0, 1, 1, 1, 0, 1])  
         
A.kernel()
```

Which will give the following result:

```python
Vector space of degree 8 and dimension 2 over Finite Field of size 2  
Basis matrix:  
[1 0 0 0 0 0 0 0]  
[0 1 1 0 0 1 1 1]  
```

These correspond to the polynomials $g_{1}(x)=1$ and $g_{2}(x)=x+x^2+x^5+x^6+x^7$. Again using Euclidean algorithm we get $\gcd(f(x),g_{2}(x))=x^6+x^5+x^4+x+1$ and $\gcd(f(x),g_{2}(x)-1)=x^2+x+1$. Then, over $\mathbb{F}_{2}$, the canonical factorization is:

$$
f(x)=(x^6+x^5+x^4+x+1)(x^2+x+1)
$$