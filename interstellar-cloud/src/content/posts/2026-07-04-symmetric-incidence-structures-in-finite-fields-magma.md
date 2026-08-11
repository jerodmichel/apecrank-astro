---
title: "Magma Code: Searching for Symmetric Incidence Structures in Finite Fields"
pubDatetime: 2026-07-04T00:00:00Z
author: "Jerod Michel"
featured: false
draft: false
tags: ["magma", "math", "incidence structures", "finite fields", "difference sets", "code snippet"]
description: "A script written in Magma to search for difference sets and almost difference sets in finite fields."
---

Here we write MAGMA code to search for difference sets and almost difference sets in finite fields. We begin by creating several functions.

```python
D := function(d,p,n)                    //creates set of dth power residues in GF(p,n)
    x := PrimitiveElement(GF(p,n))^d;
    DD := {GF(p,n)|};
    for i in {0..p^n-1} do
        Include(~DD,x^i);
    end for;
    return DD;
end function;

Di := function(d,p,n,i)             //creates set ith class of dth power residues in GF(p,n)
    x := PrimitiveElement(GF(p,n))^i;
    return {GF(p,n)|x*a:a in D(d,p,n)};
end function;

C_union := function(A,d,p,n)            //creates union of cyclotomic classes over set A of indices
    X := {};
    for i in A do
        X := X join Di(d,p,n,i);
    end for;
    return X;
end function;

C_un_plus := function(A,d,p,n,w1)       //creates additive translate of union by w1 of dth power power residues
    X := {};
    for x in C_union(A,d,p,n) do
        Include(~X,x + w1);
    end for;
    return X;
end function;

C_C_un_plus := function(A,d,p,n,w1)   //returns intersection of union of classes with additive translate of union
    return C_union(A,d,p,n) meet C_un_plus(A,d,p,n,w1);
end function;

All_d_C := function(A,d,p,n)      //collects all intersection sizes into set and returns the set       
    Z := {};
    for w1 in GF(p,n) do
        Include(~Z,# C_C_un_plus(A,d,p,n,w1));
    end for;
    return Z;
end function;
```

And here we carry out some searches.

```python
d:=6;
for n in {3} do   //searching in GF(7,3) for almost difference sets by taking unions of 6th power residues
for p in {7} do
    if IsPrime(p) then
        if p^n mod 6 eq 1 then  
            for A in Subsets({0..d-1}) do
                if # All_d_C(A,d,p,n) lt 10 then
                    print A,d,p,n,All_d_C(A,d,p,n);
                end if;
            end for;
        end if;
    end if;
end for;
end for;

d:=4;
n:=3;
for p in {5..101} do
    if IsPrime(p) then
        if p^n mod 4 eq 1 then  
            for A in Subsets({0,2},2) do
                if # All_d_C(A,d,p,n) eq 3 then
                    print A,d,p,n,All_d_C(A,d,p,n);
                end if;
            end for;
        end if;
    end if;
end for;
```