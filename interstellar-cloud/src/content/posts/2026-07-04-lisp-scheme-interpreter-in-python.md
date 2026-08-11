---
title: "A LISP/Scheme Interpreter in Python"
pubDatetime: 2013-05-15T00:00:00Z
author: "Jerod Michel"
featured: false
draft: false
tags: ["python", "lisp", "scheme", "interpreter", "peter norvig", "code snippet"]
description: "A Python implementation of a LISP/Scheme interpreter, modeled after Peter Norvig's lis.py."
---

A LISP/SCHEME interpreter in python (modeled after that from norvig.com, but for python rather than python3)

```python
import math
import operator as op

Symbol = str              # a symbol in scheme is a python string
Number = (int, float)     # a number in scheme is a python int or float
Atom   = (Symbol, Number) # an atom in scheme is a symbol or number
List   = list             # a list in scheme is a list in python
Exp    = (Atom, List)     # an expression is an atom or list
Env    = dict             # A Scheme environment (defined below) 
                          # is a mapping of {variable: value}

def Tokenize(char):
    return char.replace('(', ' ( ').replace(')', ' ) ').split() # Tokenizer

program="(begin (define r 10) (* pi (* r r)))"

def Parse(program):
    return ReadTokens(Tokenize(program)) # Parser

def Atom(token):
    try: return int(token)
    except ValueError:
        try: return float(token)
        except ValueError:
            return Symbol(token) # Atomizer

def ReadTokens(tokens):
    if len(tokens) == 0:
        print("SyntaxError: unexpected EOF")
    token = tokens.pop(0)
    if token == '(':
        L = []
        while tokens[0] != ')':
            L.append(ReadTokens(tokens))
        tokens.pop(0)
        return L
    elif token == ')':
        print("unexpected ')'")
    else:
        return Atom(token) # put tokens one by one into list

def pprint(param):
    print(param) # implement python print as a function

def standard_env():
    env = Env()
    env.update(vars(math)) # sin, cos, sqrt, pi, ...
    env.update({
        '+':op.add, '-':op.sub, '*':op.mul, '/':op.truediv,
        '>':op.gt, '<':op.lt, '>=':op.ge, '<=':op.le, '=':op.eq,
        'abs':     abs,
        'append':  op.add,
        'apply':   lambda proc, args: proc(*args),
        'begin':   lambda *x: x[-1],
        'car':     lambda x: x[0],
        'cdr':     lambda x: x[1:],
        'cons':    lambda x,y: [x] + y,
        'eq?':     op.is_,
        'expt':    pow,
        'equal?':  op.eq,
        'length':  len,
        'list':    lambda *x: List(x),
        'list?':   lambda x: isinstance(x, List),
        'map':     map,
        'max':     max,
        'min':     min,
        'not':     op.not_,
        'null?':   lambda x: x == [],
        'number?': lambda x: isinstance(x, Number),
        'print':   pprint,
        'procedure?': callable,
        'round':   round,
        'symbol?': lambda x: isinstance(x, Symbol),
    })
    return env # main translater (from python to lisp)

global_env = standard_env()
env=global_env

def eval(x):
    if isinstance(x, Symbol):        # variable reference
        return env[x]
    elif isinstance(x, Number):      # constant number
        return x                
    elif x[0] == 'if':               # conditional
        (_, test, conseq, alt) = x
        exp = (conseq if eval(test, env) else alt)
        return eval(exp)
    elif x[0] == 'define':           # definition
        (_, symbol, exp) = x
        env[symbol] = eval(exp)
    else:                            # procedure call
        proc = eval(x[0])
        args = [eval(arg) for arg in x[1:]]
        return proc(*args)

def Schemestr(exp):
    if isinstance(exp, List):
        return '(' + ' '.join(map(Schemestr, exp)) + ')' 
    else:
        return str(exp) # enter scheme expressions into this function

def repl(prompt='lis.py> '):
    while True:
        val = eval(Parse(raw_input(prompt)))
        if val is not None: 
            print(Schemestr(val)) # prompt
```