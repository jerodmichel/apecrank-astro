---
title: "Magma Code: Searching for 1 1/2-Designs in Cyclic Codes"
pubDatetime: 2011-03-04T00:00:00Z
author: "Jerod Michel"
featured: false
draft: false
tags: ["magma", "math", "cyclic codes", "incidence structures", "directed strongly regular graphs", "code snippet"]
description: "A script written in Magma to search for 1 1/2-designs in cyclic codes, which correspond to directed strongly regular graphs."
---

Here we try to find 1 1/2-designs in cyclic codes. 1 1/2-designs are interesting since they correspond to directed strongly regular graphs.

```python
D := function(d,p,n)        //creates set of dth power residues in GF(p,n)
    x := PrimitiveElement(GF(p,n))^d;
    DD := {GF(p,n)|};
    for i in {0..p^n-1} do
        Include(~DD,x^i);
    end for;
    return DD;
end function;

Di := function(d,p,n,i)     //creates ith class of dth power residues in GF(p,n)
    x := PrimitiveElement(GF(p,n))^i;
    return {GF(p,n)|x*a:a in D(d,p,n)};
end function;

C_union := function(A,d,p,n)  //creates union of cyclotomic classes over set A of indices
    X := {};
    for i in A do
        X := X join Di(d,p,n,i);
    end for;
    return X;
end function;

cTrans:=function(C,i)   //creates additive translate of union by i of dth power power residues
    X:={};
    for c in C do
        Include(~X,c+i);
    end for;
    return X;
end function;

CycBuild:=function(D,N,k,q)  //builds cyclic code of length N with D as defining set
    G:=ZeroMatrix(GF(q),k,N);
    for i in {1..k} do
        for j in {1..N} do
            if j-1 in cTrans(D,i-1,N) then
                G[i,j]:=1;
            else
                G[i,j]:=0;
            end if;
        end for;
    end for;
    return G;
end function;

ZeroCols:=function(G)   //creates set of zero columns of matrix
    X:={};
    for j in {1..NumberOfColumns(G)} do
        if Transpose(G)[j] eq ZeroMatrix(GF(2),1,NumberOfRows(G)) then
            Include(~X,j);
        end if;
    end for;
    return # X;
end function;

Build_supps:=function(C,l)   //collects supports of words in code into set
    X:={};
    for c in Words(C,l) do
        Include(~X,Support(c));
    end for;
    return X;
end function;

Check_ades:=function(b0,B,t); //check replication number of incidence structure
    X:={};
    for Y in Subsets(b0,t) do
        Z:={};
        for b in B do
            if Y subset b then
                Include(~Z,b);
            end if;
        end for;
        Include(~X,# Z);
    end for;
    return X;
end function;

Check_112:=function(F,B)  //checks whether incidence structure is a 1 1/2 design
    U:={};
    V:={};
    for x in F do
        for b in B do
            X:={};
            Y:={};
            for y in (b diff {x}) do
                for c in (B diff {b}) do
                    if y in c and x in c then
                        if x in b then
                            Include(~X,<y,c>);
                        else
                            Include(~Y,<y,c>);
                        end if;
                    end if;
                end for;
            end for;
            if x in b then
                Include(~U,# X);
            else
                Include(~V,# Y);
            end if;
        end for;
    end for;
    return [* U, V *];
end function;
```

Here we carry out a search.

```python
d:=2;            //searches for 1 1/2 designs in codes
n:=1;
q:=2;
for p in {5..201} do
    if IsPrime(p) then
        if p^n mod d eq 1 then
            G:=Set(GF(p,n));
            for A in Subsets({0..d-1},1) do
                for k in {p} do
                    C:=LinearCode(CycBuild(C_union(A,d,p,n),p,k,q));
                    for l in {3..p} do
                        B:=Build_supps(C,l);
                        if B ne {} then
                            if # Check_112(G,B)[1] eq 1 and # Check_112(G,B)[2] eq 1 and {Check_112(G,B)[1],Check_112(G,B)[2]} ne {{0},{0}} then
                                print C,A,p,k,l,Check_112(G,B),Check_ades(G,B,1),Check_ades(G,B,2),ZeroCols(CycBuild(C_union(A,d,p,n),p,k,q));
                            end if;
                        end if;
                    end for;
                end for;
            end for;
        end if;
    end if;
end for;
```