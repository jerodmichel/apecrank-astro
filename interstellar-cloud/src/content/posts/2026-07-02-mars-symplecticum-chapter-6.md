---
title: "HACKENBUSH: The Severed Root"
pubDatetime: 2026-08-09T00:00:00Z
description: "An exploration of Hackenbush, surreal numbers, and a complete implementation in bash and lisp."
author: "Jerod Michel, Gao Yucheng"
tags: ["bash", "lisp", "combinatorial game theory", "command line", "Hackenbush", "perfect information", "math"]
---

<blockquote class="text-right ml-auto max-w-2xl italic mb-8 !border-none !pl-0 before:content-none after:content-none [quotes:none]">
  <p>"The great art, then, of properly directing lines of operations is so to establish them in reference to the base and to the marches of the army as to seize the communications of the enemy without imperiling one's own, and is the most important and difficult problem in strategy."</p>
  <p class="font-bold mt-2">— Baron Antoine-Henri Jomini, The Art of War (1838), Article XXI</p>
</blockquote>

## Description

Hackenbush is a game of structural attrition played on a graph of line segments—edges—connected to one another and rooted to a "ground" line. Players take turns cutting these edges, and when an edge is severed, any part of the structure no longer connected to the ground simply falls away, as these things always do.

It is a game of gravity and supply lines whose board is a fragile ecosystem; a single cut at the root can obliterate an entire canopy. While simple variations allow either player to cut any edge, the true depth—such as it is—only emerges when edges are colored.

## History

John Conway invented the game, naming it after Groucho Marx's character, Dr. Hugo Z. Hackenbush, in the 1937 film *A Day at the Races*. It was developed to model how game values connect to surreal numbers, thereby showing that complex game positions can be represented as numbers. The game was first featured in Martin Gardner's 'Mathematical Games' column in *Scientific American* in January of 1972. It was first formally analyzed in Conway's *On Numbers and Games* in 1976, and extensively in *Winning Ways for your Mathematical Plays* in 1982 by Berlekamp, Conway and Guy.

There are two main variations of Hackenbush; there is Blue-Red Hackenbush (played on a graph where players can only cut their colored edges), and Green Hackenbush (where edges can be cut by either player). The game is a prime example of a *partisan game*, where available moves depend on which player is moving, and is often used to teach how to evaluate game complexity.

The game remains a primary tool in mathematics for demonstrating how to evaluate game complexity, bridging the gap between graph theory, topology, and the surreal number line.

## Rules and Gameplay

The game begins with the drawing a "ground" line—a horizontal line at the bottom of the playing area—and then several line segments connected to each other at endpoints (a graph), and connected to the ground, either directly at an endpoint, or indirectly via a connected series of segments (a path). Any number of segments may meet at a point, thus there may be multiple paths to ground.

On their turn, a player "cuts" (deletes) any line segment of their choosing. Every line segment no longer connected to the ground by a path "falls away" (or, gets deleted). According to normal play convention, the first player who is unable to move loses.

Hackenbush boards can consist of finitely many line segments, or infinitely many, so long as the configuration does not violate the assumption that the game can finish in a finite number of moves.

### Variants of Interest

**Original (Green) Hackenbush:** In the original version of Hackenbush, any player is allowed to cut any edge; since this is an impartial game which reduces to Nim heaps, it is straightforward describe this game using the Sprague–Grundy theorem (see Chapters 1 and 5). Therefore, the versions of Hackenbush of interest in this chapter are partisan, meaning the options (or, moves) available to one player would not necessarily be those available to the other player if it were their turn to move on the same position. This can be achieved in one of two ways:

**Blue-Red Hackenbush:** Each line segment is colored either red or blue. The *Left* (or, first) player is allowed only to cut blue line segments, while the *Right* (or, second) player is allowed only to cut red line segments.

**Blue-Red-Green Hackenbush:** Each line segment is colored red, blue, or green. The rules are the same as for Blue-Red Hackenbush, with the provision that green line segments can be cut by either player.

It is clear that Blue-Red Hackenbush is merely a special case of Blue-Red-Green Hackenbush, but it is worth noting separately, as its dissection is often much simpler.

### Green Hackenbush and Graph Reduction

Before introducing colored edges with restricted cuts (Blue-Red Hackenbush), let us consider the impartial version of the game: Green Hackenbush. In this variant, every edge is green, meaning either Left or Right may cut any edge on their turn.

Since Green Hackenbush is impartial (played under normal play convention), the Sprague-Grundy theorem applies. Every Green Hackenbush (connected) graph is equivalent to a single Nim heap of some size $n$ whose nim-value (see Chapters 4 and 5) we will denote by $*n$.

The simplest structure is that of a straight, unbranched "stalk" comprising $n$ edges. Since a player can cut any edge (causing all edges above it to fall away), a stalk of $n$ edges behaves identically to a Nim heap of size $n$. For a board consisting of several disconnected stalks, the value of the board is found simply by taking the nim-sum of the individual stalks.

Things become more complicated, however, when branches or loops are present. This brings us to two fundamental graph-reduction rules we will want to make use of: the **Colon Principle** and the **Fusion Principle**.

#### The Colon Principle (Branching)

The Colon Principle dictates how to evaluate a graph that splits into multiple branches. Therefore, when branches split from a single node, we may evaluate the game played on each branch independently, take the nim-sum of their values, and then replace the entire structure with a single straight stalk having that nim-value.

Consider the "Y-shaped" shrub below.

![Figure 1: A branched graph resolved using the Colon Principle](/hack0.png)

The shrub has a single root edge, which splits into a left branch containing one edge, and a right branch containing two edges.
1. Evaluate the branches: the left is $*1$ and the right is $*2$.
2. Take the nim-sum of the branches: $1 \oplus 2 = 3$.
3. Replace the entire canopy with a single stalk of length 3.

The graph is now computationally equivalent to a stalk of length 3 sitting atop a stalk of length 1, resulting in a single straight stalk of length 4. Therefore, this Y-shaped graph has a nim-value of $*4$.

Formally, the statement is as follows:

<div class="theorem">

**Theorem.**

Let $G_v$ denote the rooted subgame consisting of all edges above vertex $v$, treating $v$ as the local root. If $v$ has children $c_1,\dots,c_k$ (ungrounded neighbours), let $g_i = \textup{nim}(G_{c_i})$. Then
$$
\textup{nim}(G_v) = \bigoplus_{i=1}^k (g_i + 1).
$$


</div>

![Figure 2: Subgame branches](/hack1.png)

<div class="proof">

**Proof.**

We proceed by structural induction on the number of edges in $G_v$.

**Base case:** Suppose $G_v$ has no edges. Then $k=0$ and, since the empty XOR is $0$, we have $\textup{nim}(G_v)=0$. The statement holds.

**Inductive step:** Assume the statement holds for all rooted subgames having fewer edges than $G_v$. For each child $c_i$ of $v$, $G_{c_i}$ must have fewer edges, so that $g_i = \textup{nim}(G_{c_i})$ is known by the inductive hypothesis. Consider the branch $B_i$ consisting of the edge $(v,c_i)$ together with $G_{c_i}$, rooted at $v$. $B_i$ has exactly one child $c_i$ and contains fewer edges than $G_v$ (as it lacks the other branches). Applying the inductive hypothesis to $B_i$ gives us
$$
\textup{nim}(B_i) = \textup{nim}(G_{c_i}) + 1 = g_i + 1.
$$


The game $G_v$ is then the disjunctive sum of the independent branches $B_1,\dots,B_k$ as a move inside one branch does not affect the connectivity of any other branch to the root $v$. By the Sprague–Grundy theorem, the nim-value of a sum is the nim‑sum of the nim-values of its components, whence
$$
\textup{nim}(G_v) = \bigoplus_{i=1}^k \textup{nim}(B_i) = \bigoplus_{i=1}^k (g_i + 1).
$$
<div class="text-right">&#9633;</div>

</div>

#### The Fusion Principle (Cycles)

Evaluating graph cycles (loops) is notoriously difficult for computer algorithms because they can cause infinite recursion. The Fusion Principle provides an elegant mathematical bypass: *any two nodes in a cycle may be fused together without changing the nim-value of the game.*

By fusing all the nodes in a cycle together into a single point, the edges of that cycle all become isolated loops attached to that point. A single loop can be cut (which consumes a turn but drops no other edges), meaning a loop acts exactly like a single leaf edge ($*1$).

Because identical nimbers cancel each other out ($x \oplus x = 0$), we arrive at a simple, programmable rule for cycles:
*   **Even-length cycles:** Collapsing an even cycle yields an even number of loops. Since $*1 \oplus *1 = 0$, the loops cancel out. The entire cycle completely vanishes into a single point.
*   **Odd-length cycles:** Collapsing an odd cycle yields an odd number of loops. All but one cancel out, leaving a single loop. The entire cycle collapses into a single point with one attached edge ($*1$).

![Figure 3: A Green graph containing an odd cycle](/hack2.png)

Consider the graph in Figure 3, which features a triangle (a 3-edge cycle) resting on a single root edge. Because the cycle is of odd length, the Fusion Principle dictates that the triangle collapses into a single $*1$ edge. The graph simplifies to a root edge with a single edge on top, meaning this board has a final nim-value of $*2$.

Here we give the formal statement and proof which can be found in [WW82].

<div class="theorem">

**Theorem (Fusion Principle).**

Let $G$ be a finite rooted impartial Green Hackenbush graph with ground $r$. Let $C$ be any cycle in $G$. Fusing all vertices of $C$ into a single vertex (preserving all edges incident to $C$) does not change the nim-value of $G$.

</div>

<div class="proof">

**Proof.**

We proceed by contradiction, exploiting a minimal counterexample. Assume the statement is false. Consider the set of all rooted Green Hackenbush graphs for which fusing a cycle changes the nim-value. Among these, choose a graph $G$ having the smallest possible number of edges; then, among these, choose one with the fewest possible vertices.

By the minimality of $G$, the following must hold:
1. Fusing any cycle in $G$ must change the nim-value of $G$; otherwise, a smaller counterexample exists.
2. Every proper subgraph of $G$ (having strictly fewer edges) must satisfy the statement.

Select a cycle $C$ in $G$. We examine how $C$ attaches to the rest of $G$.

**Case 1: $C$ is attached to the rest of $G$ at exactly one vertex $v$.**
With $G$ rooted, the cycle $C$ forms an independent branch at vertex $v$. Since it only connects at $v$, we can evaluate it independently. A cycle of length $n$ attached at a single vertex evaluates to the nim-value $n \bmod 2$. Fusing $C$ into a single vertex replaces the cycle with $n$ independent loops. Since these loops cancel each other out via the nim-sum ($*1 \oplus *1 = 0$), $n$ loops also evaluate exactly to $n \bmod 2$. The branch's contribution to $v$ then remains identical, so that the overall nim-value of $G$ does not change. But this contradicts the assumption that $G$ is a counterexample.

**Case 2: $C$ is attached to the rest of $G$ at two or more vertices.**
Let the attachment vertices on $C$ be $v_1, v_2, \dots, v_m$ with $m \ge 2$. Consider any two distinct attachment vertices, say $v_1$ and $v_2$. The cycle $C$ then consists of two internally vertex-disjoint paths, $P$ and $Q$, between $v_1$ and $v_2$.

Since green Hackenbush is an impartial game, any path between two nodes can be simplified by nim-summing its edges. Path $P$ simplifies to a single edge (if its length is odd) or no edge (if its length is even). Path $Q$ simplifies similarly. Thus, the subgraph formed by $C$ between $v_1$ and $v_2$ is mathematically equivalent either to two parallel edges, one edge, or zero edges.

As identical options in an impartial game must cancel out, two parallel edges evaluate to $1 \oplus 1 = 0$, which is equivalent to zero edges. In all routing scenarios, the existence of the dual paths $P$ and $Q$ cancel each other out, meaning the cycle $C$ contributes nothing to the connectivity between $v_1$ and $v_2$.

Fusing all vertices of $C$ into a single vertex collapses these redundant paths, leaving the functional routing of the rest of $G$ completely unchanged. The nim-value remains the same, contradicting the assumption that $G$ is a counterexample.

Since both cases lead to a contradiction, no minimal counterexample exists. Therefore, the statement holds for all finite rooted impartial green Hackenbush graphs.<div class="text-right">&#9633;</div>
</div>

## Mathematics of Blue-Red Hackenbush

To discuss Hackenbush we will consider what is called the *surreal number line*. In the impartial games discussed in previous chapters (such as Nim or Dawson's Kayles), a game state could be evaluated using nim-values (nimbers), where identical positions mirrored and canceled each other out via the nim-sum ($x \oplus x = 0$).

Blue-Red Hackenbush operates on an entirely different foundation. Because the game is partisan—meaning Left and Right have different moves available to them—the game state has an inherent polarity. We will measure this polarity using standard real numbers (and then, eventually, surreal numbers). To see why nim-sums fall short here, consider the board in Figure 4, which contains two completely independent shrubs of different colors.

![Figure 4: A board containing two independent, monochromatic shrubs](/hack3.png)

In an impartial game like Green Hackenbush, evaluating this board would require calculating the complex nim-value of each branching structure. But in Blue-Red Hackenbush, the game is *partisan*—meaning Left and Right have different arsenals. Left can only ever interact with Shrub $B$, and Right can only ever interact with Shrub $A$.

Because they cannot legally interfere with each other's structures, the complex branching is actually an illusion. The game state simply boils down to an inherent polarity of how many guaranteed moves each player possesses.

By convention:
*   **Positive (+)** values represent an advantage for Left (Blue).
*   **Negative (--)** values represent an advantage for Right (Red).

### The Integers and the Concept of Zero

Consider the simplest possible components: a single Blue edge and a single Red edge, each rooted to the ground.

![Figure 5: Blue Stalk (+1) and Red Stalk (-1)](/hack4.png)

The Blue edge provides exactly one free move for Left, and zero moves for Right. It is worth $+1$. Conversely, the Red edge is worth $-1$.

In combinatorial game theory, we say a game (or, game state) is *balanced* if the second player to move has a guaranteed winning strategy. It is straightforward to see that balanced games always evaluate to $0$.

Let us place these two stalks on the same board:

![Figure 6: Total Value: 1 + (-1) = 0](/hack5.png)

It is easy to see that this board is balanced. This can be proved also by looking at the options:
*   **If Left moves first:** Left must cut the Blue edge. The board is now just a single Red edge ($-1$). Right then cuts the Red edge on their turn and wins. Left loses.
*   **If Right moves first:** Right must cut the Red edge. The board becomes a single Blue edge ($+1$). Left cuts this remaining edge and wins. Right loses.

Because the first player to move must lose, we can say that the board strictly evaluates to $0$. We can also see from the above illustration how any integer can be obtained when constructing a board. For example, $n$ disconnected blue segments, each rooted to the ground, evaluates to $+n$; and $n$ disconnected red segments each rooted to the ground yields $-n$.

### Fractional Moves

With the integers and the concept of balance established, we can introduce the concept of a fractional move.

To illustrate this we begin by considering a single stalk consisting of a Blue edge connected to the ground, and a Red edge sitting on top of it.

![Figure 7: What is the value of x?](/hack6.png)

Let us evaluate the options:
*   **If Right moves first:** Right cuts the top Red edge. This leaves a single Blue edge rooted to the ground. The board is now worth $+1$.
*   **If Left moves first:** Left cuts the bottom Blue edge. Gravity causes the Red edge on top to fall away, leaving an empty board (which has a value of $0$).

Left is clearly in a better position than Right—Left can immediately annihilate Right's only edge by cutting at the root. Therefore, the value of $x$ must be positive. But notice it cannot be a full $+1$, for if it was, Right could not interact with it at all (e.g., as with a lone, blue (+1) segment).

The value of this stalk must lie strictly between Left's option ($0$) and Right's option ($+1$). It turns out, as was shown in [WW82], that the stalk in question (Figure 7), has value $\frac{1}{2}$.

To see that this stalk is exactly equal to $+\frac{1}{2}$, we use the concept of balance (Zero) as defined above. If the stalk in Figure 7 were worth $x$, then placing *two* of them on the board should evaluate to $x+x$. Notice, then, that if we place an additional Red edge ($-1$) onto the board, the board should evaluate to $x+x-1$.

We show that $x + x - 1 = 0$ by showing that Right has a guaranteed winning strategy on the board in question.

![Figure 8: Two 1/2 stalks and one -1 stalk](/hack7.png)

Suppose Left moves first. Left's only move is to cut the bottom Blue edge of one of the two stalks containing a blue edge. The entire stalk then falls away (including the red edge it contains). The board now consists of one $x$ stalk and one $-1$ stalk. The total value, then, is $x-1$. It is easy to see that Right has a guaranteed winning strategy from this position (and that the value of $x-1$ must be negative).

Suppose now that Right moves first. If Right cuts the lonely $-1$ Red stalk, the board becomes two $x$ stalks, totalling $x+x$. It is easy to see that Left inevitably wins from this position. If instead Right cuts the top Red edge of one of the $x$ stalks, that stalk then becomes a single Blue edge worth $+1$, leaving the other $x$ stalk and the $-1$ stalk, again a winning position for Left (whence $x + 1 - 1 = x > 0$). Therefore, Right loses in every case.

Since the second player to move is guaranteed a winning strategy, the value of this board must $0$. Therefore, two of these two-colored stalks perfectly balances one whole Red stalk, so that $x + x = 1$, from which comes $x = \frac{1}{2}$.

### Dyadic Fractions

We proved by balance that the stalk in Figure 7 evaluates to $\frac{1}{2}$. But how do we evaluate a novel stalk without merely guessing a fraction and testing it against a zero-sum board?

John Conway devised a notation for describing this logic, which became the foundation for the surreal number system. A game state $V$ is defined entirely by the options available to the two players, and can be written as:
$$
V = \{L \mid R\},
$$
where $L$ is the value of the board after Left makes its best available move, and $R$ is the value of the board after Right makes its best available move.

Recall that the $\frac{1}{2}$ stalk (a Red edge resting on top of a Blue edge). Left's only move was to cut the Blue root, leaving an empty board (with value $0$). Right's only move was to cut the top Red edge, leaving a single Blue edge ($+1$). Therefore, this stalk can be written as:
$$
V = \{0 \mid 1\}.
$$


But how is $\{0 \mid 1\}$ equivalent to $\frac{1}{2}$?

#### Generating Smaller Fractions

Let us use balance to verify the Simplicity Rule for smaller fractions. Consider a stalk consisting of a Blue edge at the root, a Red edge in the middle, and another Red edge on top.

![Figure 9: A stalk evaluating to 1/4](/hack8.png)

Let us evaluate the options for this new stalk, which we will call $y$:
*   **Left's Best Move ($L$):** Left's only legal move is to cut the Blue root. Due to gravity, the two Red edges fall away, leaving $0$.
*   **Right's Best Move ($R$):** Right has two choices. Right could cut the middle Red edge (leaving a pure Blue edge worth $+1$). Or, Right could cut the top Red edge. If the top Red edge is cut, the remaining stalk is a Red edge resting atop a Blue edge, which we have already shown is worth $\frac{1}{2}$. As Right is trying to minimize the score, leaving $\frac{1}{2}$ is strictly better than leaving $+1$.

Plugging these optimal moves into Conway's notation, the value of the stalk becomes:
$$
y = \left\{0 \mathrel{\Big|} \frac{1}{2}\right\}.
$$


Note that, according to Conway's Simplicity Rule, which we will discuss shortly, the simplest dyadic fraction between $0$ and $\frac{1}{2}$ is $\frac{1}{4}$. We can, however, show this while staying within the game's context. Placing *two* of these stalks onto the board should perfectly balance with a single $-\frac{1}{2}$ stalk (a Blue edge resting on a Red root).

![Figure 10: A board used to prove y + y - 1/2 = 0](/hack9.png)

We invite the reader to show formally that either of the stalks shown on the left-hand-side of figure 10 evaluates to $\frac{1}{4}$ by considering the options available to each player, and that this board yields the equation $y + y - \frac{1}{2} = 0$. (Hint: verify that the first player to move on this board is guaranteed to lose, exactly as we demonstrated with $x + x - 1 = 0$.)

#### Conway's Notation and the Simplicity Rule

We have made some progress toward being able to play some versions of Hackenbush and, with less complicated boards, being able to tell which side will win. We can now consider a bit more formal approach as, so far, the tools at our disposal will not get us far with more complex boards.
Let's introduce a more formal notation. For a game $G$, we write
$$
\{l_0,l_1,l_2,...\mid r_0,r_1,r_2,...\} ,
$$

for a board from which Left can move to a board worth $l_0, l_1, l_2,...$ For our purposes it will suffice to denote a 1-turn advantage to Left simply as $+1$, and a 1-turn advantage to Right as $-1$.

With this notation, the integers may be expressed as follows:
$$
0 = \{ \mid \}, 1 = \{0\mid \}, 2 = \{1\mid \},..., -1 = \{ \mid 0\}, -2 = \{ \mid -1\},...
$$


For example, recall the board containing the two monochromatic shrubs from Figure 4. Because Left has 5 guaranteed moves on the pure Blue shrub and Right has 3 guaranteed moves on the pure Red shrub, the initial board value is simply $-3 + 5 = 2$.

If we map out all the possible board states left by each player's available cuts (keeping in mind that cutting a trunk removes more edges via gravity than cutting a terminal branch), the entire game can be formally expressed as $\{-3, 0, 1 \mid 3, 5\}$.

For the sake of simplicity, we will sometimes omit all but the largest value for Left’s options, and all but the smallest value for Right’s, as we may assume that each player plays in their best interest—so that the board from Figure 4 can be expressed simply as $\{1 \mid 3\}$.

<div class="definition">

**Definition.**

For a game $G$ with possible moves 
$$
\{l_0, l_1, l_2,...\mid r_0, r_1, r_2,...\},
$$
if $l_i$ and $r_i$ are numbers for each $i$, we say the number $x$ *fits* if it is strictly greater than $l_i$ and strictly less than $r_i$ for each $i$. A number $x$ that fits is called the *simplest number* that fits if none of its possible moves fit—i.e., neither $a$ nor $b$ should fit into $G$ whenever $x = \{a\mid b\}$.

</div>

For example, for Figure 11 below, which can be expressed as $\{ -\frac{3}{4}\mid -\frac{1}{4}, \frac{1}{2}\}$, the numbers $-\frac{3}{8}$ and $-\frac{5}{8}$ both fit, but only $-\frac{1}{2}$ is the simplest number to fit, as neither of its options $-1$ or $0$ (as $-\frac{1}{2}=\{ -1\mid 0\}$) fit.

![Figure 11](/hack10.png)

This leads us to the actual statement of the Simplicity Rule:

<div class="theorem">

**Theorem (Simplicity Rule).**

If at least one number fits into a game
$$
G = \{l_0, l_1, l_2,...\mid r_0, r_1, r_2,...\},
$$
then $G$ is equal to $x$, where $x$ is the simplest such number.

</div>

<div class="proof">

**Proof.**

Notice first that games can be added to each other in a natural way—i.e., two Hackenbush boards can be combined by allowing Right and Left to play on either board in turns. Also, when combining boards in this way, the value of any such sum is simply the sum of their individual components—for, since the individual boards are disconnected, the moves in one do not affect those in another.
We can thusly describe the inverse of a game, $H = \{l\mid r\}$, by $-H = \{-r\mid -l\}$, as $H + (-H)$ would then yield a zero game, for if Left leads with either $l$ or $-r$, Right simply responds (resp.) with either $-l$ or $r$, thereby ensuring a win for Right; a similar argument shows a guaranteed win for Left when Right leads.
Returning to the original discussion, without loss of generality, we can write the game $G$ as $\{a\mid b\}$ simply ignoring any strictly dominated options available to either player. Let $x = \{c\mid d\}$ be the simplest number that fits into $G$, so that $a < x < b$. Since $x$ is strictly the simplest number to fit into $G$, its options $c$ and $d$ (which are simpler than $x$) cannot fit into $G$, and so we must have $c \leq a$ and $d \geq b$. Now consider the game $G + (-x) = \{a\mid b\} + \{-d\mid -c\}$.

If Left leads, there are only two choices: either Left applies the move $a$ (in $G$), so that the board becomes $a-x$, in which case Right clearly has a winning strategy since $a < x$;  or Left applies the move $-d$ (in $-x$), so that the board becomes $G - d$, in which case Right responds with the move $b$, leaving $b-d$. Since $d\geq b$ we have $b-d\leq 0$, and Right must win.

If Right leads, there are also only two choices: Right could apply the move $b$ (in $G$), yielding the board $b-x$ which we know positive, and Left is guaranteed to win. Or, Right could apply the move $-c$ (in $-x$), yielding the board $G-c$. Left then responds with the move $a$ (in $G$), leaving $a-c$, which again guarantees a win for Left since $c\leq a$.

Since the second player to move is guaranteed to win in every scenario, $G + (-x)$ must be a zero game, i.e., $G - x = 0$, whence $G = x$.
<div class="text-right">&#9633;</div>

</div>

<div class="remark">

**Remark.**

Finding these "simplest numbers" can, at first glance, seem daunting. To systemize this, in [WW82], Berlekamp, Conway, and Guy introduced a genealogical number tree. The tree is constructed by generation: $0$ is born on day zero (the simplest game, $\{ \mid \}$), followed by $1$ and $-1$ on day one, and so on. To find the simplest number for any game $\{L \mid R\}$, one simply follows a branche straight down from the root of the tree until hitting the very first number that fits strictly between the options for the best $L$ and the best $R$.

![Figure 12: Tree of Simplest Numbers](/hack11.png)

By repeating this process, inductively, we can assign a definitive number to *any* blue-red Hackenbush board, thereby knowing the winner of any game before it begins.

Consider the shrub below, for example. While evaluating the entire canopy at once might seem confusing, we can recursively break it down into individual cases, map out the $\{L \mid R\}$ options, and apply the Simplicity Rule.

![Figure 13](/hack12.png)

Let us evaluate this shrub:

**Left's Best Move:** Left's only move is to cut the top Blue branch. This leaves a straight Red stalk of length 2, which has a value of $-2$.

**Right's Best Move:** Right has two choices. Cutting the Red trunk destroys the whole shrub, leaving $0$. Cutting the top Red branch leaves a Red trunk with a Blue canopy. (If we evaluate that specific sub-game, Left cutting the Blue canopy leaves $-1$, and Right cutting the Red trunk leaves $0$. Thus, that sub-game is $\{-1 \mid 0\} = -\frac{1}{2}$). Since Right wants to minimize the score, leaving $-\frac{1}{2}$ is strictly better than leaving $0$.

The total game is therefore $\{-2 \mid -\frac{1}{2}\}$. If we look at our number tree in Figure 12, the first (simplest) number that appears strictly between $-2$ and $-\frac{1}{2}$ is $-1$.

Therefore, this entire shrub evaluates perfectly to $-1$. Skeptical readers are invited to verify that this shrub is in fact worth exactly $-1$ move by drawing it on a board alongside a lone blue edge ($+1$) to balance it, and proving that the second player to move on that board is guaranteed to win.

</div>

### Exercise in Evaluation

Understanding how alternating colors affect the value is the key to mastering Blue-Red Hackenbush. Consider the following:

![Figure 14: What is the value of this stalk?](/hack13.png)

We invite the reader to evaluate this stalk using Conway's notation.
*Hint: Carefully map out the board states left by each player's available cuts. Find $\{L \mid R\}$ and apply the Simplicity Rule.*

## Blue-Red-Green Hackenbush and Infinitesimals

Thus far, we have evaluated purely impartial boards (Green Hackenbush), which simplify to nim-values, and purely partisan boards (Blue-Red Hackenbush), which simplify to real or surreal fractions. But what happens when we mix these?

Blue-Red-Green Hackenbush is the ultimate synthesis. To evaluate these mixed boards algorithmically, we must understand how fractions and nim-values interact.

### The Star (*) and the Dominance Rule

Let us begin with the simplest possible green structure: a single green edge rooted to the ground.

![Figure 15](/hack14.png)

Because this edge is green, either Left or Right may cut it. If Left cuts it, the board is empty and worth $0$. If Right cuts it, the board is empty and worth $0$. In Conway's notation, this game is expressed as $\{0 \mid 0\}$.

We introduced this in earlier chapters as the nim-value $*1$, but when present among real numbers (as it will be in blue-red-green Hackenbush), it is traditionally denoted by "$*$", and referred to as *star*.

Mathematically, $*$ is a fascinating entity. As the first player to move on a $*$ board (Figure 15) always wins, the game is not a zero-game. However, nor is it strictly positive (an advantage for Left) or strictly negative (an advantage for Right). In combinatorial game theory, we say that $*$ is *confused* with $0$, and write "$* \mid\mid 0$".

#### The Dominance of Numbers over Star
How should one (or, even a computer) evaluate a board that contains both a fraction and a star? Consider the board in Figure 16, which features a blue-red stalk worth $+\frac{1}{2}$ alongside a separate Green edge worth $*$.

![Figure 16: A mixed board](/hack15.png)

The total value of this board is $\frac{1}{2} + *$. While the star makes the game slightly "fuzzy," it does not change the ultimate outcome. It is not difficult to check that Left still has a guaranteed winning strategy, so that $\frac{1}{2}$ turns out to be a true numerical advantage.

This leads us to a hard, programmable logic branch.

<div class="theorem">

**Theorem (The Dominance of Numbers over Star).**

Let $x$ be a non-zero real number. Then the game $x + *$ has the same outcome as the game $x$.

</div>

<div class="proof">

**Proof.**

We prove the case $x > 0$; the case $x < 0$ follows by symmetry (negating both sides).

Assume $x > 0$. In canonical form, every Right option of $x$ is a positive number (by the simplicity theorem, since all Right options must be strictly greater than $x$, and $x > 0$).

To show that $x + * > 0$, we must demonstrate that Left wins regardless of who moves first.

**If Left moves first:** Left simply moves in $*$ to $0$. The position becomes $x + 0 = x$. Since $x > 0$, Left has a guaranteed winning strategy from this position.

**If Right moves first:** Right has two choices. If Right moves in $*$ to $0$, the position becomes $x + 0 = x$. Since $x > 0$, Right has handed the board to Left in a strictly positive state, resulting in a Left win.

Alternatively, if Right moves in $x$ to some Right option $x^R$, then $x^R > 0$ and the position becomes $x^R + *$. By structural induction on the game tree, $x^R + * > 0$. Hence, Left possesses a winning strategy from this position as well. (The base case for this induction, such as $x = 1 = \{0 \mid \}$, holds trivially because Right has no legal moves within $x$, forcing Right to move in $*$ and immediately leaving $x$).

Since every move by Left leads to a Left win, and every first move by Right leads to a Left win, $x + * > 0$. Therefore, $x + *$ is strictly positive whenever $x > 0$.
<div class="text-right">&#9633;</div>

</div>

Therefore, if the numerical part of a board evaluates to a strictly positive number ($x > 0$), Left will always win, completely ignoring the presence of any stars. If $x < 0$, Right wins. Star only decides the winner when the numerical value of the board is exactly $0$.

### A Comment on Infinitesimals

What happens when colors mix within the same branching structure in a way that gives one player a tiny, almost imperceptible advantage?

Consider a game defined as $\{0 \mid *\}$. In this game, Left's best move leaves $0$, while Right's best move leaves a star ($*$). Conway defined this specific game state as **Up**, denoted by $\uparrow$. (Its inverse, $\{* \mid 0\}$, is **Down**, denoted by $\downarrow$).

Mathematically, $\uparrow$ is strictly positive, meaning Left has a winning strategy. However, it is an *infinitesimal*. It is strictly greater than $0$, but it is strictly smaller than any positive fraction you can possibly construct in Hackenbush. $\uparrow$ is smaller than $\frac{1}{2}$, smaller than $\frac{1}{1024}$, and smaller than $\frac{1}{2^{100}}$.

Since representing $\uparrow$ with a (simple) blue-green-red Hackenbush board is non-trivial, we introduce it here as a concept.

![Figure 17: Recursive Game Trees for Up and Down](/hack16.png)

Fascinatingly, these infinitesimals operate on their own miniature integer system completely hidden within the margins of zero. They can accumulate and cancel each other out:

**Cancellation:** A board with one Up and one Down evaluates exactly to zero ($\uparrow + \downarrow = 0$). The board is perfectly balanced.

**Accumulation:** Placing two Ups on a board yields a strictly larger advantage for Left, i.e., $\uparrow + \uparrow = \Uparrow$, which we refer to as *double up*.

However, the dominance of real numbers remains absolute. No matter how many ups one accumulates on a board, their combined sum ($\Uparrow+\Uparrow+\uparrow\cdots$) will *never* surpass even the smallest positive fractional advantage.

In pure mathematics, proving the exact size and properties of $\uparrow$ requires a complicated transfinite induction. This is where the recursive power of Conway's $\{L \mid R\}$ notation shines. We can pass any game state that equating to $\{0 \mid *\}$ into a standard Negamax (or Minimax) algorithm; the computer does not need to understand what an infinitesimal is—it will simply search the tree. Left's move evaluates to $0$. Right's move evaluates to $*$, from which the next player's move evaluates to $0$. The algorithm naturally discovers the winning strategy through logical branching.

### Atomic Weight and the Flower Rule

Because infinitesimals and stars are so incredibly small, determining who is winning on a complex mixed-color board can be difficult. To measure who ultimately holds the advantage in games that are "confused" with zero, we will use a concept called *atomic weight*.

The atomic weight of a game strips away the "fuzziness" of stars and infinitesimals, and returns a simple integer that tells of the core momentum of the game. For example, if a game has an atomic weight of $+2$, Left is clearly in control. We will approach this topic first by introducing the concept of a flower, and the flower rule.

<div class="definition">

**Definition.**

A *flower* is a specific Hackenbush structure consisting of a single green edge rooted to the ground (the stem), supporting a canopy. The canopy may consist of any arbitrary, connected graph formed entirely of blue and red edges.

</div>

How do we determine the value of a single flower? Conway, in [WW82], provides an elegant shortcut: *To find the atomic weight of a flower, delete the green stem, drop the entire canopy directly to the ground, and evaluate the resulting blue-red game.*

For example, a flower with a canopy consisting of a single blue petal evaluates to $+1$ when dropped to the ground. Therefore, its atomic weight is $+1$.

A *flower garden* is simply a collection of completely green Hackenbush structures (shrubbery) together with one or more flowers. This brings us to the following definition.

<div class="definition">

**Definition (Atomic Weight).**

We define the *atomic weight* of a blue flower to be $+1$ and that of a red flower to be $-1$; the *atomic weight* of a given garden is consequently defined as the sum of the atomic weights of all of the flowers in the garden.
</div>

![FIG: Atomic](/hack17.png)

Since independent structures rooted to the ground form a disjunctive sum, their atomic weights combine using standard arithmetic. Therefore, a garden containing $b$ independent blue flowers (each having weight $+1$) and $r$ independent red flowers (each having weight $-1$) has a total atomic weight of $b - r$.

How might two players tend such a garden? Let us first consider the simple case described in Figure 18 below. The board consists of a single blue flower alongside some green shrubbery. By the flower rule, the atomic weight of the board is $+1$.

If Left goes first, there are two choices—either take the petal from the flower, or cut down some greenery. Ignoring Left’s single petal, we could just evaluate the entire garden as a green Hackenbush board, and assign it a nim-value. If the nim-value turns out to be $0$, Left can simply pluck the petal, hand the zero game over to Right, and ignore the flower for the rest of the game, securing a win. If the nim-value is greater than $0$, then Left can reduce it to $0$ by cutting only green edges while avoiding the flower, and can win this way. Therefore, if one player has a single flower, the other player has no flower, and the player having the flower has the first move, then the player with the flower is guaranteed a win. By extension, in a garden with weight $\pm 2$, the player with the advantage will win regardless of who goes first, as the opponent can cut only one edge at a time.

We have thus shown the following:

<div class="theorem">

**Theorem (Atomic Weight Advantage).**

Let $G$ be a flower garden with an atomic weight $w$. If $w \ge 1$ and Left moves first, Left is guaranteed a win. By extension, if $w \ge 2$, Left is guaranteed a win regardless of who moves first. (By symmetry, the inverse holds for Right for $w \le -1$ and $w \le -2$).

</div>

### Parted Jungles and Maximal Flows

We can now extend our study to a generalization of the flower garden. A *parted jungle* is an arbitrary green Hackenbush board supporting a canopy of red and blue edges, such that no red edges touch any blue edges, and no red or blue edges touch the ground.

To discuss how to hack through such a jungle algorithmically, we need a few more definitions.

<div class="definition">

**Definition.**

In a parted jungle, a *track* is a simple path consisting entirely of green edges. We distinguish between two types of tracks: a *contested track* connects a vertex in the blue canopy directly to a vertex in the red canopy, and a *residual track* connects a vertex in either colored canopy directly to the ground. A *flow* is a set of contested tracks, with the strict condition that no two tracks may share the same green edge. A flow is *maximal* if it contains as many contested tracks as possible.

</div>

In a parted jungle, Left (blue) and Right (red) are fundamentally competing for the structural capacity of the green stems. As a green edge can be cut only once, contested tracks represent shared vulnerabilities—if a green stem supports both a blue petal and a red petal, cutting that stem affects the canopy of both players. The players are ultimately fighting to isolate and secure their own connections to the ground while threatening their opponent's.

To evaluate who holds the advantage in this shared green network, we must first account for this mutually contested space. We do this by calculating the maximal flow *between* the two canopies.

By directing the flow *from* the blue canopy, *through* the green stems, and *into* the red canopy, we algorithmically identify and "pair off" the paths where Left and Right can actively threaten each other's structures. Only once this contested flow is fully saturated can we examine the remaining green edges to discover how many uncontested residual tracks each player can guarantee directly to the ground.

![Figure 19: Parted Jungle](/hack18.png)

Given a parted jungle, it will always be possible to identify the disjoint sets of purely blue and purely red canopies. To calculate the net atomic weight, we begin constructing a directed flow.

First, identify as many continuous paths as possible running from the blue set to the red set, taking care to not use any green edge more than once and ensuring no path touches the ground, and drawing an arrow to label the direction traveled. This marks the initial state of our capacity network, as shown in Figure 20.

![Figure 20: Initial state showing two isolated flow paths](/hack19.png)

To formalize this, we must define how a path can be constructed through a partially saturated network.

<div class="definition">

**Definition (Augmenting Path).**

Given a parted jungle with an existing (possibly empty) flow, an *augmenting path* is a sequence of connected green edges starting at a blue canopy vertex and ending at a red canopy vertex, such that every step along the path satisfies one of two conditions:
1. that it traverses an *unused* green edge, or
2. that it traverses a *used* green edge in the *opposite* direction of its current flow.

</div>

If an augmenting path forces a track to travel backwards along an edge that is already directed, it is effectively "canceling" or "double-crossing" the previous flow, redirecting it to a more optimal route. This allows for early correction of sub-optimal choice of path in the algorithm. See Section 7.2 for a formal statement of this special case of the Ford-Fulkerson algorithm.

#### Atomic Weight of a Parted Jungle

By saturating the maximal flow from the blue canopy to the red canopy, we can successfully identify all of the "contested" capacity within the green stems. Every track in this flow represents a path where Left and Right can actively block or sever each other's connection to the ground.

With the contested flow accounted for, we can now define the true macroscopic advantage of the board by looking for an *enlargement*.

An enlargement is found by attempting to route as many additional tracks—i.e. tracks that are edge-disjoint with those of the saturated maximal flow we just discussed—as possible from either of the colored canopies directly to the ground, using only the green edges that were *not* used in the maximal flow.

![Figure 21: Evaluated State of a Parted Jungle](/hack20.png)

It is important to note that this enlargement might yield residual tracks for both canopies. While a contested path from blue to red cannot be formed by joining two residual tracks (since the ground is a terminal base and is not traversable), it is entirely possible for both players to secure independent connections to the ground—for instance, if they occupy completely separate green shrubs.

Therefore, we must count the number of residual tracks secured by Left, and those secured by Right, and find the net difference (as is illustrated in Figure 21). This brings us to our final rule for evaluating a parted jungle:

<div class="theorem">

**Theorem (Atomic Weight of a Parted Jungle).**

In a parted jungle, let $b$ be the number of residual tracks from the blue canopy to the ground, and $r$ be the number of residual tracks from the red canopy to the ground, found after saturating the maximal flow. The atomic weight of the parted jungle is exactly $b - r$.

</div>

<div class="proof">

**Proof.**

We show that the net residual tracks in a parted jungle behave identically to the net flowers in a flower garden.

Suppose our enlargement yields $b$ blue residual tracks and $r$ red residual tracks. Even if every contested track in the maximal flow is perfectly neutralized by optimal play, Left is guaranteed $b$ uncontested tracks to the ground, and Right is guaranteed $r$ uncontested tracks to the ground.

Since these tracks are mutually isolated from the opponent's influence within the green canopy, they function exactly like the stems of $b$ blue flowers and $r$ red flowers. The remainder of the jungle—the contested flow network and any extraneous green edges—behave merely as neutral green shrubbery.

Just as in a flower garden, the $b$ blue tracks and $r$ red tracks offset each other. If $b > r$, Left possesses $b - r$ strictly advantageous tracks. Left can evaluate the nim-value of the underlying green shrubbery (including the contested paths). If the nim-value is positive, Left makes a reducing move in the green edges, forcing Right to respond. If the nim-value is exactly $0$, Left simply cuts one of their $b - r$ net residual tracks, passing the zero-game back to Right.

Continuing in this manner, Right will eventually exhaust all legal responses in the contested space, while Left safely relies on their positive margin of residual tracks. Therefore, by Theorem 5.1, Left is guaranteed a win if the net atomic weight $b - r \ge 1$ with the first move, or if $b - r \ge 2$ regardless of who moves first.<div class="text-right">&#9633;</div>
</div>

## Winning Strategy and Example of Gameplay

As the theorems established in the previous section naturally dictate optimal play, we can demonstrate the winning strategy simply by walking through the parted jungle shown in Figure 19 (and evaluated in Figure 21).

Recall that our analysis revealed a saturated contested flow and an enlargement yielding $b$ $(= 2)$ blue residual tracks and $r$ $(= 1)$ red residual track, giving the board a net atomic weight of $+1$.

Since $w \ge 1$, Left is guaranteed to win by Theorem 5.1 if they have the first move. To execute this win, Left must strictly treat their two residual tracks (see Figure 21) as a safe reserve, and focus their immediate attention on the remaining green edges—the shrubbery—which includes the contested aerial bridge.

If we ignore the red and blue canopies, the green network on this specific board forms an impartial game. Because the left, center, and right trees are all physically linked together by green aerial bridges, any cut alters the topology of the entire structure. By systematically applying the Fusion Principle to collapse the internal cycles (such as the parallel bends in the trunks) and the grounded loops formed by the aerial bridges, this 21-edge network mathematically reduces exactly to three independent green leaves attached to the ground. Since three isolated leaves evaluate to a nim-sum of $1 \oplus 1 \oplus 1 = 1$, the entire green network on this board is mathematically equivalent to a game of Nim played with a single heap of size $1$ (with nim-value $*1$).

Because the nim-value is positive ($*1$), Left must then treat the green edges exactly as a game of Nim, and make a calculated cut somewhere in the green network that drops the total nim-value from $*1$ to exactly $0$. This neutralizes the impartial game and forces Right to respond in the contested space.

If Right eventually returns a nim-value of exactly $0$, Left will simply ignore the green network entirely and reach into their reserve. Left can sever one of their two uncontested tracks to the ground, and then cleanly pass the $0$-game back to Right without altering the balance of the contested space.

As the game progresses, Right is continually forced to respond to Left's zero-sum traps in the green canopy. Structural attrition takes hold, and eventually, the contested space will be entirely pruned away.

Right, having exhausted all mutual edges, will be forced to cut their single residual track. Left, resting safely on their remaining residual track, will make the final cut of the game.

## Play Hackenbush in Command Line (with Lisp for game engines)

Before presenting our implementation of Hackenbush, we will first cover some foundational algorithms which it uses, and make a few general remarks om its architecture.

### Foundational Algorithms: Negamax and Alpha-Beta Pruning

As introduced in Chapter 4 (Dots and Boxes), zero-sum games of perfect information can be navigated effectively using minimax algorithm with alpha-beta pruning. For our implementation of Hackenbush, we will utilize a more elegant, streamlined variant of this logic known as *negamax*.

<div class="definition">

**Definition (Negamax Algorithm).**

The *negamax* algorithm is a variant of minimax that relies on the zero-sum property of a two-player game that simplifies the search. It operates on the identity $\max(a, b) = -\min(-a, -b)$, meaning that the value of a position to player A is simply the negation of that value to player B. This eliminates any need to alternate explicitly between "maximizing" and "minimizing" within the code.

</div>

<pre><code class="language-plaintext">function negamax(position, depth, alpha, beta, color)
    if depth == 0 or game_over(position)
        return color * evaluate(position)
    
    maxEval = -inf
    for each child of position
        eval = -negamax(child, depth-1, -beta, -alpha, -color)
        maxEval = max(maxEval, eval)
        alpha = max(alpha, eval)
        if alpha >= beta
            break  # cutoff
    return maxEval
</code></pre>


Notice that, in the recursive call, the $\alpha$ and $\beta$ bounds are inverted and negated (`-beta, -alpha`), as well as the evaluated score. This allows the algorithm to evaluate the board from the perspective of whichever player is currently moving.

In our depth-limited Hackenbush search, the heuristic evaluation function (`evaluate`) will take into account:
*   the simulation of gravity, identifying all edges that fall as a result of a cut,
*   simple material advantage based on remaining colors (e.g., tallying $+1$ for blue edges and $-1$ for red edges), and
*   for deeper, more rigorous evaluations, the underlying atomic weight or maximal flows as were discussed in Section 3.3.

<div class="example">

**Example (Pruning in Hackenbush).**

Consider a position where Left (the maximizer) has found a cut that guarantees a net material advantage of $+2$ edges ($\alpha = 2$). If Right (the minimizer) simulates a response cut that immediately drops a massive Blue canopy, resulting in a score of $-3$, Right's best guaranteed outcome for that branch becomes negated in the recursive step. Since the negated bounds will trigger an $\alpha \geq \beta$ cutoff, the remaining responses on that branch need not be evaluated, as Left we assume would not willingly choose a path that is doomed.

</div>

### Foundational Algorithms: Ford-Fulkerson

To determine maximal flow without relying on visual intuition, we employ a unit-capacity variant of the Ford-Fulkerson algorithm. Since each green edge can be cut only once, it can support exactly one contested track. Therefore, we can find the maximal flow simply by searching for valid paths and updating the directions of the edges we traverse. The following algorithm (which was also discussed in Section 5.4) will be used only in the "Hard" level of our AI engine and, obviously, only when the board strictly satisfies the definition of a parted jungle.

<pre><code class="language-plaintext">Initialize all green edges as unused (no directed flow).
While an augmenting path exists from the blue canopy to the red canopy
    For each edge traversed in the augmenting path
        If the edge was unused
            Mark it as used and direct it forward along the path.
        Else
            // The edge was used, and we are traversing it backwards
            Mark it as unused (remove its direction).
        End If
    End For
End While
return the final set of directed green edges as the maximal flow.
</code></pre>


### Architectural Overview

We will employs a hybrid architecture focusing on structural graph manipulation:
*   **Bash**: Orchestrates game flow, I/O handling, SVG rendering, and coordinates Lisp computations.
*   **Common Lisp**: Implements procedural graph generation, the gravity engine, and the negamax tree search.
*   **Strategic Foundation**: The AI utilizes:
    *   material evaluation heuristics for depth-limited tactical strikes,
    *   dynamic graph topology mapping to identify critical load-bearing trunks, and
    *   alpha-beta pruning to efficiently bypass unfavorable branches without. exhaustive calculation.

This separation leverages Bash's scripting strength for process management with Lisp's symbolic computation for recursive geometric decision-making.

<div class="remark">

**Remark (Practical Implementation).**

While comprehensive game tree searches evaluating to the exact surreal values were considered, our implementation focuses on computationally tractable topological heuristics:
*   simulating the `apply-gravity` function to project future board states,
*   identifying immediate, devastating material swings, and
*   scaling difficulty by adjusting the depth limit of the negamax search tree.

These techniques provide a highly aggressive, tactical AI that strictly adheres to the mathematical realities of the game without requiring infinite recursion.

</div>

### Game Orchestration (Bash)
The Bash component manages the user interface (where input is command line and output is an svg file) and menus where the player may choose a diffilculty level, board size or color.

```bash
#!/bin/bash

echo "========================================="
echo "         WELCOME TO HACKENBUSH           "
echo "========================================="
echo " "

# choose color
while true; do
    read -p "Choose your color ('b' for Blue, 'r' for Red): " color_choice
    case "$color_choice" in
        b|B|blue|Blue)
            PLAYER_COLOR="blue"
            break
            ;;
        r|R|red|Red)
            PLAYER_COLOR="red"
            break
            ;;
        *)
            echo "Invalid choice. Please enter 'b' for Blue or 'r' for Red."
            ;;
    esac
done

echo " "

# choose ai difficulty
while true; do
    read -p "Choose AI difficulty ('e' for Easy, 'm' for Medium, 'h' for Hard): " diff_choice
    case "$diff_choice" in
	e|E|easy|Easy)
	    AI_DIFFICULTY="easy"
	    break
	    ;;
	m|M|medium|Medium)
	    AI_DIFFICULTY="medium"
	    break
	    ;;
	h|H|hard|Hard)
	    AI_DIFFICULTY="hard"
	    break
	    ;;
	*)
	    echo "Invalid choice. Please enter 'e', 'm' or 'h'."
	    ;;
    esac
done

echo " "

# choose board size
while true; do
    read -p "Choose board size ('s' for Small, 'l' for Large): " size_choice
    case "$size_choice" in
        s|S|small|Small)
            BOARD_SIZE="small"
            break
            ;;
        l|L|large|Large)
            BOARD_SIZE="large"
            break
            ;;
        *)
            echo "Invalid choice. Please enter 's' or 'l'."
            ;;
    esac
done

echo " "
echo "========================================="
echo "You are playing as: ${PLAYER_COLOR^}"
echo "AI difficulty: ${AI_DIFFICULTY^}"
echo "========================================="
echo " "

# 1. call lisp to generate initial board.svg
sbcl --script hackenbush_functions.lisp init "$PLAYER_COLOR" "$AI_DIFFICULTY" "$BOARD_SIZE"

# detect os and open SVG appropriately
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    open -g board.svg
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # linux: Eye of GNOME (eog)
    eog board.svg > /dev/null 2>&1 &
elif [[ "$OSTYPE" == "msys"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
    # windows (running via Git Bash or Cygwin)
    start board.svg
else
    echo "OS not recognized. Please open board.svg manually in your viewer."
fi

# 3. start the game loop
while true; do
    echo " "
    read -p "Enter an edge to cut (or 'q' to quit): " move
    
    if [[ "$move" == "q" ]]; then
        echo "Thanks for playing!"
        break
    fi
    
    # 4. pass move to lisp, sending the player's color so Lisp knows who the human is
    OUTPUT=$(sbcl --script hackenbush_functions.lisp move "$move" "$PLAYER_COLOR" 2>&1)
    
    # echo ALL BUT invisible trigger phrase
    echo "$OUTPUT" | grep -v "AI_TURN_NEXT"
    
    # 5. check if game is over
    if echo "$OUTPUT" | grep -q "Game Over!"; then
        echo " "
        echo "================================="
        echo " GAME OVER! "
        echo "================================="
        read -p "Press Enter to exit..."
        break
    fi
    
    # 6. check if AI's turn
    if echo "$OUTPUT" | grep -q "AI_TURN_NEXT"; then
        # pause for 1.5 seconds for human to  see their cut fall
        sleep 1.5 
        echo " "
        echo "AI is thinking..."
        sleep 1 # pause briefly for effect
        
        # trigger AI Lisp calc
        AI_OUTPUT=$(sbcl --script hackenbush_functions.lisp ai-turn "$PLAYER_COLOR" "$AI_DIFFICULTY" 2>&1)
        
        # echo AI output, hiding any triggers
        echo "$AI_OUTPUT" | grep -v "AI_TURN_NEXT"
        
        # check if AI won
        if echo "$AI_OUTPUT" | grep -q "Game Over!"; then
            echo " "
            echo "================================="
            echo " GAME OVER! "
            echo "================================="
            read -p "Press Enter to exit..."
            break
        fi
    fi
    
    # image viewer automatically refreshes image here
done
```

### AI Engine (Common Lisp)
The Lisp component handles game flow, state managemant, the building of boards in an interesting and random manner, and the strategic AI using negamax and Ford-Fulkerson algorithms.

```lisp
;; Define structure for a Hackenbush edge
(defstruct edge
  id      ; string or character (e.g., "A", "1")
  color   ; string ("blue", "red", "green")
  x1 y1   ; start coordinates
  x2 y2)  ; end coordinates
    
    ;; loop through edges and draw them
(defun generate-svg (edges filename)
  (with-open-file (stream filename :direction :output :if-exists :supersede)
    ;; write SVG header
    (format stream "<svg width=\"800\" height=\"600\" xmlns=\"http://www.w3.org/2000/svg\">~%")

    ;; DRAW WHITE BACKGROUND
    (format stream "  <rect width=\"800\" height=\"600\" fill=\"white\"/>~%")
    
    ;; draw ground line
    (format stream "  <line x1=\"50\" y1=\"550\" x2=\"750\" y2=\"550\" stroke=\"gray\" stroke-width=\"8\"/>~%")
    
    ;; loop through edges and draw each
    (dolist (e edges)
      ;; draw line
      (format stream "  <line x1=\"~a\" y1=\"~a\" x2=\"~a\" y2=\"~a\" stroke=\"~a\" stroke-width=\"6\"/>~%"
              (edge-x1 e) (edge-y1 e) (edge-x2 e) (edge-y2 e) (edge-color e))
      
      ;; DRAW VERTICES (black dots at both ends of each edge)
      (format stream "  <circle cx=\"~a\" cy=\"~a\" r=\"6\" fill=\"black\"/>~%" (edge-x1 e) (edge-y1 e))
      (format stream "  <circle cx=\"~a\" cy=\"~a\" r=\"6\" fill=\"black\"/>~%" (edge-x2 e) (edge-y2 e))
      
      ;; calculate midpoint for label
      (let ((mid-x (/ (+ (edge-x1 e) (edge-x2 e)) 2))
            (mid-y (/ (+ (edge-y1 e) (edge-y2 e)) 2)))
        
        ;; draw text label slightly offset to right, and up
        (format stream "  <text x=\"~a\" y=\"~a\" text-anchor=\"middle\" font-family=\"monospace\" font-size=\"20\" font-weight=\"bold\" fill=\"black\">~a</text>~%"
                (+ mid-x 12) (- mid-y 8) (edge-id e))))
    
    ;; close SVG tag
    (format stream "</svg>~%")))

;; -----------------------------------------
;; PLAYER COLOR CHOICE
;; -----------------------------------------


(defparameter *player-color* :blue)   ; default
(defparameter *ai-color* :red)        ; default
(defparameter *ai-difficulty* :easy)  ; default

(defun set-player-color (choice)
  "Set player color based on 'b' or 'r'"
  (cond
    ((or (string-equal choice "b") (string-equal choice "blue"))
     (setf *player-color* :blue
           *ai-color* :red)
     (format t "You are BLUE. AI is RED.~%"))
    ((or (string-equal choice "r") (string-equal choice "red"))
     (setf *player-color* :red
           *ai-color* :blue)
     (format t "You are RED. AI is BLUE.~%"))
    (t (format t "Invalid choice. Default: You are BLUE.~%"))))

;; -----------------------------------------
;; BASIC MECHANICS OF MOVES
;; -----------------------------------------


;; 1. check if coord is touhing ground
(defun on-ground-p (y)
  (>= y 550))
  
;; 2. check if two edges share a vertex
(defun edges-connected-p (e1 e2)
  (or (and (= (edge-x1 e1) (edge-x1 e2)) (= (edge-y1 e1) (edge-y1 e2)))
      (and (= (edge-x1 e1) (edge-x2 e2)) (= (edge-y1 e1) (edge-y2 e2)))
      (and (= (edge-x2 e1) (edge-x1 e2)) (= (edge-y2 e1) (edge-y1 e2)))
      (and (= (edge-x2 e1) (edge-x2 e2)) (= (edge-y2 e1) (edge-y2 e2)))))
      
;; 3. gravity engine
(defun apply-gravity (current-edges)
  "returns list of edges still grounded"
  (let ((survivors '())
        (queue '()))
   
   ;; step A: find all grounded edges
   (dolist (e current-edges)
     (when (or (on-ground-p (edge-y1 e)) (on-ground-p (edge-y2 e)))
       (push e queue)
       (push e survivors)))
       
   ;; step B: trace all connections up into canopy
   (loop while queue do
     (let ((current (pop queue)))
       (dolist (e current-edges)
         ;; if 'e' is connected to 'current' and isn't already saved...
         (when (and (not (member e survivors))
                    (edges-connected-p current e))
           (push e queue)          ; add to queue to check neighbors
           (push e survivors)))))  ; save from falling
           
   ;; return list of surviving edges
   survivors))
   
;; validate move
(defun valid-move-p (board edge-id)
  "check if edge exists and can be cut"
  (and edge-id
       (not (string= edge-id ""))
       (find-if (lambda (e) (string-equal (edge-id e) edge-id)) board)))

;; take edge passed by user and apply move to board
(defun make-move (board edge-id-to-cut)
  ;; 1. remove cut edge from board
  (if (not (valid-move-p board edge-id-to-cut))
      (progn
        (format t "Lisp: Invalid move! Edge '~a' doesn't exist.~%" edge-id-to-cut)
        board) ; return unchanged board
      ;; 2. valid move - proceed
      (let ((board-after-cut (remove-if (lambda (e) (string-equal (edge-id e)
        edge-id-to-cut))
                                    board)))
      ;; 3. apply gravity to see what falls
      (apply-gravity board-after-cut))))
       
;; -----------------------------------------
;; STATE MANAGEMENT
;; -----------------------------------------


(defun load-state-values (filename)
  "return list with: board, player, move-number"
  (multiple-value-list (load-state filename)))

(defun save-state (edges filename &key (current-player :blue) (move-number 0))
  "serializes edge structs into simple list and saves to file"
  (with-open-file (stream filename :direction :output :if-exists :supersede)
    (print (list :edges (mapcar (lambda (e)
                     (list (edge-id e) (edge-color e)
                           (edge-x1 e) (edge-y1 e)
                           (edge-x2 e) (edge-y2 e)))
                 edges)
           :player current-player
           :move-number move-number)
            stream)))
            
(defun load-state (filename)
  "reads list from file and rebuilds edge structs"
  (with-open-file (stream filename :direction :input)
    (let* ((raw-data (read stream))
           (edges-data (getf raw-data :edges))
           (player (getf raw-data :player :blue))  ; blue is default
           (move-num (getf raw-data :move-number 0)))
      (values (mapcar (lambda (data)
                        (make-edge :id (first data) :color (second data)
                                   :x1 (third data) :y1 (fourth data)
                                   :x2 (fifth data) :y2 (sixth data)))
                      edges-data)
              player
              move-num))))
              
;; -----------------------------------------
;; TURN MANAGEMENT AND WIN DETECT
;; -----------------------------------------


(defun switch-player (current-player)
  "switch from :blue to :red or visa versa"
  (if (eq current-player :blue) :red :blue))
  
(defun legal-moves-exist-p (board player)
  "check whether player has legal moves"
  (some (lambda (e)
        (or (string-equal (edge-color e) "green")
            (string-equal (edge-color e) (string-downcase (symbol-name player)))))
       board))
       
(defun check-win (board current-player)
  "returns winning player or nil if game continues"
  (let ((next-player (switch-player current-player)))
    (cond
      ;; if NEXT player has no moves, current player wins
      ((not (legal-moves-exist-p board next-player))
        current-player)
      ;; if CURRENT player has no moves (should not happen), next player wins
      ((not (legal-moves-exist-p board current-player))
        next-player)
      ;; game continues
      (t nil))))
      
(defun get-valid-move-feedback (board edge-id player)
  "return feedback about why a move is invalid, or nil if valid"
  (cond
    ((not (valid-move-p board edge-id))
      (format nil "Edge '~a' does not exist!" edge-id))
    ((let ((edge (find edge-id board :key #'edge-id :test #'string-equal)))
      (and edge
           (not (string-equal (edge-color edge) "green"))
           (not (string-equal (edge-color edge) (string-downcase (symbol-name player))))))
      (format nil "You can only cut green edges or edges of your own color (~a)!"
              (string-downcase (symbol-name player))))
    (t nil)))
    
;; -----------------------------------------
;; AI ENGINEs
;; -----------------------------------------


;; easy AI
(defun get-random-legal-move (board player)
  "return random legal edge-id for player, or nil if none"
  (let ((legal-edges (remove-if-not
                       (lambda (e)
                         (or (string-equal (edge-color e) "green")
                             (string-equal (edge-color e) (string-downcase (symbol-name player)))))
                                 board)))
       (if legal-edges
         (edge-id (nth (random (length legal-edges)) legal-edges))
         nil)))
         
(defun ai-move-easy (board player difficulty)
  (declare (ignore difficulty))
  (get-random-legal-move board player))

;; 1. material & structural heuristic
(defun evaluate-board (board)
  "evaluates material advantage, plus fractional weight for load-bearing green stems"
  (let ((blue-count 0)
        (red-count 0)
        (green-blue-touches 0)
        (green-red-touches 0))
    
    ;; count pure material
    (dolist (e board)
      (cond ((string-equal (edge-color e) "blue") (incf blue-count))
            ((string-equal (edge-color e) "red")  (incf red-count))))
    
    ;; map structural support (does a green edge touch a colored canopy?)
    (dolist (g board)
      (when (string-equal (edge-color g) "green")
        (dolist (c board)
          (when (edges-connected-p g c)
            (cond ((string-equal (edge-color c) "blue") (incf green-blue-touches))
                  ((string-equal (edge-color c) "red")  (incf green-red-touches)))))))
    
    ;; blue advantage positive, red advantage negative
    ;; green edges touching blue (or red) act as structural armor (+0.1)
    (+ (- blue-count red-count)
       (* 0.1 green-blue-touches)
       (* -0.1 green-red-touches))))

;; helper: get list of legal edge IDs
(defun get-legal-moves (board player)
  "returns list of legal edge-ids for given player"
  (let ((player-color (string-downcase (symbol-name player))))
    (mapcar #'edge-id 
            (remove-if-not (lambda (e)
                             (or (string-equal (edge-color e) "green")
                                 (string-equal (edge-color e) player-color)))
                           board))))

;; 2. NEGAMAX ALGORITHM with alpha-beta pruning
(defun negamax (board depth alpha beta color player)
  "evaluates board using depth-limited negamax and gravity projection."
  (let ((legal-moves (get-legal-moves board player)))
    ;; if depth limit reached or no legal moves exist, return heuristic score
    (if (or (<= depth 0) (null legal-moves))
        (* color (evaluate-board board))
        (let ((max-eval -1000000)
              (next-player (switch-player player)))
          (dolist (move legal-moves)
            ;; simulate cut and apply gravity
            (let* ((board-after-cut (remove-if (lambda (e) (string-equal (edge-id e) move)) board))
                   (new-board (apply-gravity board-after-cut))
                   ;; recursively call negamax with bounds flipped and polarity
                   (eval (- (negamax new-board (1- depth) (- beta) (- alpha) (- color) next-player))))
              
              (setf max-eval (max max-eval eval))
              (setf alpha (max alpha eval))
              ;; alpha-Beta cutoff
              (when (>= alpha beta)
                (return))))
          max-eval))))

;; 3. medium AI strategy
(defun ai-move-medium (board player difficulty)
  "medium difficulty: Depth-2 negamax search optimizing for material advantage."
  (declare (ignore difficulty)) 
  (let* ((legal-moves (get-legal-moves board player))
         (best-move nil)
         (best-score -1000000)
         (color (if (eq player :blue) 1 -1))
         (next-player (switch-player player))
         (depth 2)) ;; cap depth at 2 for medium level
    
    (if (null legal-moves)
        nil
        (progn
          (dolist (move legal-moves)
            ;; simulate each possible move from root
            (let* ((board-after-cut (remove-if (lambda (e) (string-equal (edge-id e) move)) board))
                   (new-board (apply-gravity board-after-cut))
                   ;; start negamax search tree for simulated board
                   (score (- (negamax new-board (1- depth) -1000000 1000000 (- color) next-player))))
              
              ;; keep track of highest scoring move
              (when (> score best-score)
                (setf best-score score)
                (setf best-move move))))
          
          ;; fallback if everything evaluates equally badly
          (if best-move best-move (first legal-moves))))))

;; -----------------------------------------
;; HARD AI: MATHEMATICAL PREDICATES
;; -----------------------------------------


(defun parted-jungle-p (board)
  "checks if board is strictly a parted jungle."
  (let ((is-parted t))
    
    ;; rule 1: no red or blue edges rooted to ground
    (dolist (e board)
      (when (and (not (string-equal (edge-color e) "green"))
                 (or (on-ground-p (edge-y1 e)) (on-ground-p (edge-y2 e))))
        (setf is-parted nil)))
    
    ;; rule 2: no red edge touches any blue edge
    (dolist (e1 board)
      (when (string-equal (edge-color e1) "red")
        (dolist (e2 board)
          (when (and (string-equal (edge-color e2) "blue")
                     (edges-connected-p e1 e2))
            (setf is-parted nil)))))
            
    is-parted))

;; -----------------------------------------
;; MAXIMAL FLOW: NETWORK MAPPING
;; -----------------------------------------

(defun get-nodes (edge)
  "returns two (x . y) coordinate pairs for an edge."
  (list (cons (edge-x1 edge) (edge-y1 edge))
        (cons (edge-x2 edge) (edge-y2 edge))))

(defun find-flow-boundaries (board)
  "finds sources (blue meets green), sinks (red meets green), and ground nodes. Returns (values sources sinks ground-nodes)"
  (let ((sources '())
        (sinks '())
        (ground-nodes '())
        (green-edges (remove-if-not (lambda (e) (string-equal (edge-color e) "green")) board))
        (blue-edges  (remove-if-not (lambda (e) (string-equal (edge-color e) "blue")) board))
        (red-edges   (remove-if-not (lambda (e) (string-equal (edge-color e) "red")) board)))
    
    (dolist (g green-edges)
      (let ((g-nodes (get-nodes g)))
        (dolist (node g-nodes)
          
          ;; check if node touches the ground
          (when (on-ground-p (cdr node))
            (pushnew node ground-nodes :test #'equal))
            
          ;; check if node touches a blue edge (source)
          (dolist (b blue-edges)
            (when (or (equal node (cons (edge-x1 b) (edge-y1 b)))
                      (equal node (cons (edge-x2 b) (edge-y2 b))))
              (pushnew node sources :test #'equal)))
              
          ;; check if this node touches a red edge (sink)
          (dolist (r red-edges)
            (when (or (equal node (cons (edge-x1 r) (edge-y1 r)))
                      (equal node (cons (edge-x2 r) (edge-y2 r))))
              (pushnew node sinks :test #'equal))))))
              
    (values sources sinks ground-nodes)))

(defun build-residual-graph (green-edges)
  "builds adjacency list for green edges. 
   Format: (node-coord . ((neighbor-coord . edge-id) ...))"
  (let ((graph (make-hash-table :test #'equal)))
    (dolist (e green-edges)
      (let ((n1 (cons (edge-x1 e) (edge-y1 e)))
            (n2 (cons (edge-x2 e) (edge-y2 e)))
            (id (edge-id e)))
        ;; add forward and backward paths (capacity 1 in both directions initially)
        (push (cons n2 id) (gethash n1 graph))
        (push (cons n1 id) (gethash n2 graph))))
    graph))

;; -----------------------------------------
;; MAXIMAL FLOW: FORD-FULKERSON
;; -----------------------------------------

(defun find-augmenting-path (graph sources sinks)
  "Breadth-First Search to find a path from any source to any sink."
  (let ((queue (copy-list sources))
        (visited (make-hash-table :test #'equal))
        (parents (make-hash-table :test #'equal)))
    
    ;; Mark sources as visited
    (dolist (s sources)
      (setf (gethash s visited) t))
      
    (loop while queue do
      (let ((current (pop queue)))
        
        ;; If we reached a sink, reconstruct and return the path
        (when (member current sinks :test #'equal)
          (let ((path '())
                (curr current))
            (loop while (gethash curr parents) do
              (let* ((p-info (gethash curr parents))
                     (parent-node (car p-info))
                     (edge-id (cdr p-info)))
                ;; Path step format: (from-node to-node edge-id)
                (push (list parent-node curr edge-id) path)
                (setf curr parent-node)))
            (return-from find-augmenting-path path)))
            
        ;; Otherwise, explore neighbors
        (dolist (neighbor-info (gethash current graph))
          (let ((next-node (car neighbor-info))
                    (edge-id (cdr neighbor-info)))
            (unless (gethash next-node visited)
              (setf (gethash next-node visited) t)
              (setf (gethash next-node parents) (cons current edge-id))
              ;; Add to back of queue for BFS
              (setf queue (append queue (list next-node))))))))
    nil)) ;; Return nil if no path found

(defun get-maximal-flow (board)
  "returns list of edge-ids making up the saturated contested flow"
  (multiple-value-bind (sources sinks ground-nodes)
      (find-flow-boundaries board)
    (declare (ignore ground-nodes))
    (let* ((green-edges (remove-if-not (lambda (e) (string-equal (edge-color e) "green")) board))
           (graph (build-residual-graph green-edges))
           ;; tracks active flow direction. Maps edge-id to '(from-node . to-node)
           (flow-states (make-hash-table :test #'equal))) 
      
      (loop
        (let ((path (find-augmenting-path graph sources sinks)))
          (if (null path)
              (return) ;; no more augmenting paths exist and flow is maximal
              
              ;; path found, so update graph capacities and flow states
              (dolist (step path)
                (let* ((u (first step))
                       (v (second step))
                       (edge-id (third step))
                       (current-flow (gethash edge-id flow-states)))
                  
                  ;; 1. update the residual graph capacities
                  ;; remove forward capacity just traversed not to  be used again
                  (setf (gethash u graph)
                        (remove-if (lambda (n-info) (string-equal (cdr n-info) edge-id))
                                   (gethash u graph)))
                  
                  ;; ensure backward capacity exists so algorithm can double-cross later
                  (pushnew (cons u edge-id) (gethash v graph) :test #'equal)
                  
                  ;; 2. update actual flow state (matching our mathematics)
                  (if current-flow
                      ;; if was already used, we are traversing backwards, so mark as unused
                      (remhash edge-id flow-states)
                      ;; if was unused, mark as used in u -> v direction
                      (setf (gethash edge-id flow-states) (cons u v))))))))
                      
      ;; return IDs of all edges actively carrying flow
      (loop for edge-id being the hash-keys of flow-states collect edge-id))))

;; -----------------------------------------
;; MAXIMAL FLOW: RESIDUAL TRACKS & ATOMIC WEIGHT
;; -----------------------------------------

(defun count-residual-tracks (green-edges start-nodes ground-nodes)
  "counts max disjoint paths from start-nodes to ground-nodes using provided green edges."
  (let ((graph (build-residual-graph green-edges))
        (track-count 0))
    
    (loop
      (let ((path (find-augmenting-path graph start-nodes ground-nodes)))
        (if (null path)
            (return track-count) ;; No more paths to ground
            
            ;; path found
            (progn
              (incf track-count)
              
              ;; update capacities to prevent edges from being reused
              (dolist (step path)
                (let ((u (first step))
                      (v (second step))
                      (edge-id (third step)))
                  
                  ;; remove forward capacity
                  (setf (gethash u graph)
                        (remove-if (lambda (n-info) (string-equal (cdr n-info) edge-id))
                                   (gethash u graph)))
                  
                  ;; add backward capacity for double-crossing
                  (pushnew (cons u edge-id) (gethash v graph) :test #'equal)))))))))

(defun calculate-atomic-weight (board)
  "returns the atomic weight (b - r) of a parted jungle."
  (multiple-value-bind (blue-sources red-sinks ground-nodes)
      (find-flow-boundaries board)
    
    (let* ((contested-ids (get-maximal-flow board))
           (all-green (remove-if-not (lambda (e) (string-equal (edge-color e) "green")) board))
           
           ;; create enlargement (green edges NOT used in contested flow)
           (residual-green (remove-if (lambda (e) 
                                        (member (edge-id e) contested-ids :test #'string-equal)) 
                                      all-green))
           
           ;; b: max flow from blue to ground
           (b (count-residual-tracks residual-green blue-sources ground-nodes))
           
           ;; r: max flow from red to ground
           (r (count-residual-tracks residual-green red-sinks ground-nodes)))
      
      ;; return the net atomic weight
      (- b r))))

;; 4. HARD AI ENGINE
(defun evaluate-board-hard (board)
  "evaluates board using Atomic Weight as primary, and material as tie-breaker"
  (if (parted-jungle-p board)
      ;; if parted, atomic weight dominates (* 100), but material acts as tie-breaker
      (+ (* 100 (calculate-atomic-weight board))
         (evaluate-board board))
      ;; if tangled, fall entirely back to material advantage
      (evaluate-board board)))

(defun negamax-hard (board depth alpha beta color player)
  "deep negamax using the atomic weight heuristic and checkmate detection"
  (let ((legal-moves (get-legal-moves board player)))
    (cond
      ;; 1. CHECKMATE: current player has no legal moves and loses immediately.
      ;; We add `depth` so that AI prefers slower losses and faster wins
      ((null legal-moves) (+ -1000000 depth))
      
      ;; 2. DEPTH LIMIT: evaluate board heuristic
      ((<= depth 0) (* color (evaluate-board-hard board)))
      
      ;; 3. RECURSIVE SEARCH
      (t
       (let ((max-eval -1000000)
             (next-player (switch-player player)))
         (dolist (move legal-moves)
           (let* ((board-after-cut (remove-if (lambda (e) (string-equal (edge-id e) move)) board))
                  (new-board (apply-gravity board-after-cut))
                  (eval (- (negamax-hard new-board (1- depth) (- beta) (- alpha) (- color) next-player))))
             (setf max-eval (max max-eval eval))
             (setf alpha (max alpha eval))
             (when (>= alpha beta)
               (return))))
         max-eval)))))

(defun ai-move-hard (board player difficulty)
  "hard difficulty: Depth-3 search optimized by Atomic Weight and Maximal Flow."
  (declare (ignore difficulty)) 
  (let* ((legal-moves (get-legal-moves board player))
         (best-move nil)
         (best-score -1000000)
         (color (if (eq player :blue) 1 -1))
         (next-player (switch-player player))
         (depth 3)) ;; depth 3 is mathematically vicious with this heuristic
    
    (if (null legal-moves)
        nil
        (progn
          ;; Print a terminal diagnostic so the human knows they are in trouble!
          (when (parted-jungle-p board)
            (let ((weight (calculate-atomic-weight board)))
              (format t "    [MATHEMATICS] Parted Jungle! True Atomic Weight: ~a~%" weight)))
          
          (dolist (move legal-moves)
            (let* ((board-after-cut (remove-if (lambda (e) (string-equal (edge-id e) move)) board))
                   (new-board (apply-gravity board-after-cut))
                   (score (- (negamax-hard new-board (1- depth) -1000000 1000000 (- color) next-player))))
              
              (when (> score best-score)
                (setf best-score score)
                (setf best-move move))))
          
          (if best-move best-move (first legal-moves))))))

;; 5. master AI dispatcher
(defun ai-move (board player difficulty)
  "routes AI move request to correct difficulty  engine."
  (cond
    ((string-equal difficulty "easy")
     (ai-move-easy board player difficulty))
    
    ((string-equal difficulty "medium")
     (ai-move-medium board player difficulty))
    
    ((string-equal difficulty "hard")
     (ai-move-hard board player difficulty))
    
    ;; default fallback in case of typos in bash
    (t 
     (ai-move-easy board player difficulty))))
  
;; -----------------------------------------
;; NETWORK GRAMMAR FOR BUILDING BOARDS
;; -----------------------------------------


;; grid and layer definitions
(defparameter *layers*
  '((ground . 550)   ; layer 0
    (trunk  . 430)   ; layer 1
    (branch . 310)   ; layer 2
    (canopy . 190))) ; layer 3

(defparameter *columns* '(100 200 300 400 500 600 700))  ; 7 columns

(defun layer-y (layer-name)
  (cdr (assoc layer-name *layers*)))

(defun col-x (col-index)
  (nth col-index *columns*))

(defun make-node-at (id col layer)
  (list :id id 
        :x (col-x col) 
        :y (layer-y layer)
        :col col 
        :layer layer))

(defparameter *network-patterns*
  `(
  	;; PATTERN 0: simple trunk (straight line)
    (:name "Simple-Trunk"
     :nodes ((:id root :type "green" :col 3 :layer ground)
             (:id g1   :type "green" :col 3 :layer trunk))
     :edges ((root g1)))
     
    ;; PATTERN 1: simple contested stem
    (:name "Contested-Stem"
     :nodes ((:id root :type "green" :col 3 :layer ground)
     				 (:id g1 :type "green" :col 3 :layer trunk)
             (:id b1 :type "blue"  :col 2 :layer branch)
             (:id r1 :type "red"   :col 4 :layer branch))
     :edges ((root g1)
     				 (g1 b1)
     				 (g1 r1)))

    ;; PATTERN 2: colorful triangle loop
    (:name "Triangle-Loop"
     :nodes ((:id base :type "green" :col 3 :layer branch)
             (:id left :type "blue"  :col 2 :layer canopy)
             (:id rght :type "red"   :col 4 :layer canopy)
             (:id apex :type "green" :col 3 :layer canopy))
     :edges ((base left) (base rght) (left apex) (apex rght)))
    
    ;; PATTERN 3: aerial bridge
    (:name "Aerial-Bridge"
     :nodes ((:id left  :type "green" :col 1 :layer branch)
             (:id right :type "green" :col 5 :layer branch))
     :edges ((left right)))
    
    ;; PATTERN 4: cross-braced parallel trunks
    ;; i.e., two trunks with horizontal cross-braces
    (:name "Cross-Braced-Trunks"
     :nodes ((:id t1 :type "green" :col 2 :layer trunk)
             (:id t2 :type "green" :col 4 :layer trunk)
             (:id b1 :type "green" :col 3 :layer branch)
             (:id c1 :type "green" :col 2 :layer branch)
             (:id c2 :type "green" :col 4 :layer branch))
     :edges ((t1 t2)   ; lower cross-brace
             (c1 c2)   ; upper cross-brace
             (t1 c1)   ; left vertical
             (t2 c2)   ; right vertical
             (b1 c1)   ; diagonal brace
             (b1 c2))) ; diagonal brace
    
    ;; PATTERN 5: hub and spoke canopy
    (:name "Hub-and-Spoke"
     :nodes ((:id hub  :type "green" :col 3 :layer branch)
             (:id b1   :type "blue"  :col 2 :layer canopy)
             (:id r1   :type "red"   :col 4 :layer canopy)
             (:id g1   :type "green" :col 2 :layer branch)
             (:id g2   :type "green" :col 4 :layer branch))
     :edges ((hub b1) (hub r1) (hub g1) (hub g2)))))
                 
(defparameter *global-edge-counter* 0)

(defun generate-jungle-from-patterns (&optional (size "small"))
  "generate structured jungle without overlapping edges"
  (let ((all-edges '())
        (previous-anchor nil) 
        (columns (if (string-equal size "large")
                     '(0 2 4 6)     
                     '(1 3 5)))     
        
        ;; look up ALL patterns by name
        (trunk-pat (find-if (lambda (p) (string-equal (getf p :name) "Simple-Trunk")) *network-patterns*))
        (stem-pat  (find-if (lambda (p) (string-equal (getf p :name) "Contested-Stem")) *network-patterns*))
        (hub-pat   (find-if (lambda (p) (string-equal (getf p :name) "Hub-and-Spoke")) *network-patterns*))
        (tri-pat   (find-if (lambda (p) (string-equal (getf p :name) "Triangle-Loop")) *network-patterns*))) 
    
    (dolist (col columns)
      ;; 1. always plant bare trunk base
      (multiple-value-bind (base-edges base-nodes)
          (instantiate-single-pattern trunk-pat col 0)
        
        (setf all-edges (append all-edges base-edges))
        
        ;; 2. determine anchor and CANOPY TYPE
        (let* ((anchor (gethash 'g1 base-nodes))
               ;; ROLL 3-SIDED DICE FOR CANOPY
               (canopy (let ((roll (random 3)))
                         (cond ((= roll 0) stem-pat)
                               ((= roll 1) hub-pat)
                               (t tri-pat))))) 
          
          (multiple-value-bind (canopy-edges canopy-nodes)
              (instantiate-single-pattern canopy col 0 anchor)
            (declare (ignore canopy-nodes))
            (setf all-edges (append all-edges canopy-edges)))
          
          ;; 3. AERIAL BRIDGE: randomly connect to previous tree
          (when previous-anchor
            (when (= (random 2) 0) 
              (let* ((px (getf previous-anchor :x))
                     (py (getf previous-anchor :y))
                     (ax (getf anchor :x))
                     (ay (getf anchor :y))
                     (mid-x (/ (+ px ax) 2))
                     (mid-y ay))
                
                ;; helper function to preventing branch collision
                (flet ((edge-exists-p (ex1 ey1 ex2 ey2)
                         (find-if (lambda (e)
                                    (or (and (= (edge-x1 e) ex1) (= (edge-y1 e) ey1)
                                             (= (edge-x2 e) ex2) (= (edge-y2 e) ey2))
                                        (and (= (edge-x1 e) ex2) (= (edge-y1 e) ey2)
                                             (= (edge-x2 e) ex1) (= (edge-y2 e) ey1))))
                                  all-edges)))
                  
                  ;; left bridge segment (only draw if missing)
                  (unless (edge-exists-p px py mid-x mid-y)
                    (push (make-edge :id (format nil "e~a" (incf *global-edge-counter*))
                                     :color "green" :x1 px :y1 py :x2 mid-x :y2 mid-y)
                          all-edges))
                  
                  ;; right bridge segment (only draw if missing)
                  (unless (edge-exists-p mid-x mid-y ax ay)
                    (push (make-edge :id (format nil "e~a" (incf *global-edge-counter*))
                                     :color "green" :x1 mid-x :y1 mid-y :x2 ax :y2 ay)
                          all-edges))))))
          
          (setf previous-anchor anchor))))
    
    all-edges))
				
(defun network-complexity-score (edges)
  "high score = interesting topology"
  (+ (if (has-cycle-p edges) 3 0)
     (* 2 (count-biconnected-components edges))
     (count-nodes-with-degree edges 3)     ; branch points
     (count-nodes-with-degree edges 4)))   ; hubs
				
(defun interesting-jungle-p (green-edges blue-edges red-edges)
  (and
    ;; must have at least one cycle
    (has-cycle-p green-edges)
    
    ;; must have at least one contested track
    (has-contested-track-p green-edges blue-edges red-edges)
    
    ;; must have at least 2 stems
    (>= (count-ground-connections green-edges) 2)
    
    ;; must have some branching (node degree > 2)
    (has-branching-p green-edges)
    
    ;; optional: complexity score
    (>= (network-complexity-score green-edges) 5)))
    
;; -----------------------------------------
;; TEST BOARDS
;; -----------------------------------------


;; MISC FUNCTIONS
(defun find-matching-node (id node-map)
  "find node in map by ID"
  (gethash id node-map))

(defun determine-edge-type (from-node to-node)
  "determine edge color based on node type"
  (let ((from-type (getf from-node :type))
        (to-type (getf to-node :type)))
    (cond
      ((or (eq from-type :blue) (eq to-type :blue)) "blue")
      ((or (eq from-type :red) (eq to-type :red)) "red")
      (t "green"))))

(defun add-ground-connections (all-nodes all-edges)
  "stub: return edges unchanged for now"
  (declare (ignore all-nodes))
  all-edges)

(defun convert-to-edge-structs (all-nodes all-edges)
  "convert internal representation to edge structs"
  (let ((edges '())
        (counter 0))
    (dolist (e all-edges)
      (let* ((from-id (getf e :from))
             (to-id (getf e :to))
             (from-node (gethash from-id all-nodes))
             (to-node (gethash to-id all-nodes))
             (edge-type (getf e :type)))
        (when (and from-node to-node)
          (push (make-edge :id (format nil "e~a" (incf counter))
                          :color edge-type
                          :x1 (getf from-node :x) :y1 (getf from-node :y)
                          :x2 (getf to-node :x) :y2 (getf to-node :y))
                edges))))
    edges))

(defun hash-table-keys (ht)
  "return list of keys in hash table"
  (loop for key being the hash-keys of ht collect key))

(defun test-pattern-generator ()
  "generate composite board test anchor snapping"
  
  ;; 1. build base (pattern 0: contested-stem)
  (multiple-value-bind (base-edges base-nodes) 
      (instantiate-single-pattern (nth 0 *network-patterns*) 3 0)
    
    ;; 2. find exact coordinates of trunk's top node ('g1)
    (let ((anchor (gethash 'g1 base-nodes)))
      
      ;; 3. build canopy (pattern 4: hub-and-spoke), passing the anchor
      (multiple-value-bind (canopy-edges canopy-nodes)
          (instantiate-single-pattern (nth 4 *network-patterns*) 0 0 anchor)
        (declare (ignore canopy-nodes))
        
        ;; 4. combine both lists into single jungle
        (let ((all-edges (append base-edges canopy-edges)))
          
          ;; draw combined board
          (generate-svg all-edges "board.svg")
          all-edges)))))

(defun instantiate-single-pattern (pattern col-offset layer-offset &optional anchor-node)
  "quick instantiation for testing"
  (declare (ignore layer-offset))
  (let ((edges '())
        (node-map (make-hash-table))
        (base-x (if anchor-node (getf anchor-node :x) (col-x col-offset)))
        (base-y (if anchor-node (getf anchor-node :y) (layer-y 'ground))))
    
    ;; create nodes
    (dolist (spec (getf pattern :nodes))
      (let* ((id (getf spec :id))
             (first-node (first (getf pattern :nodes)))
             (x (+ base-x (* (- (getf spec :col) (getf first-node :col)) 100)))
             (y (+ base-y (- (layer-y (getf spec :layer)) (layer-y (getf first-node :layer)))))
             (node-type (getf spec :type)))
        (setf (gethash id node-map)
              (list :id id :x x :y y :type node-type))))
    
    ;; create edges
    (dolist (edge-spec (getf pattern :edges))
      (let ((from (gethash (first edge-spec) node-map))
            (to   (gethash (second edge-spec) node-map)))
        (when (and from to)
          ;; edge color should be color of 'leaf' node
          ;; if 'to' is green, use 'from's color. Otherwise use 'to's color
          (let ((edge-color (if (string-equal (getf to :type) "green")
                                (getf from :type)
                                (getf to :type))))
            (push (make-edge :id (format nil "e~a" (incf *global-edge-counter*))
                             :color edge-color
                             :x1 (getf from :x) :y1 (getf from :y)
                             :x2 (getf to :x) :y2 (getf to :y))
                  edges)))))
    
    (values edges node-map)))

;; -----------------------------------------
;; MAIN ENTRY POINT (CLI ROUTER)
;; -----------------------------------------


(setf *random-state* (make-random-state t))

(let ((args sb-ext:*posix-argv*))
  (when (>= (length args) 2)
    (let ((command (second args)))
      (cond
        ;; command 1: init game with configuration
	((string-equal command "init")
	 (let* ((player-color (if (>= (length args) 3) 
				 (third args) 
				 "blue"))
	       (difficulty (if (>= (length args) 4)
			       (fourth args) 
			       "easy"))
	       (board-size (if (>= (length args) 5)
			       (fifth args)
			       "small"))
	       ;; generate board using pattern
	       (board (generate-jungle-from-patterns board-size)))
	   
	   ;; set player configuration
	   (set-player-color player-color)
	   (setf *ai-difficulty* (cond
				   ((string-equal difficulty "easy") :easy)
				   ((string-equal difficulty "medium") :medium)
				   ((string-equal difficulty "hard") :hard)
				   (t :easy)))
	   
	   ;; initialize board with generated edges
	   (save-state board "board.dat" :current-player :blue :move-number 0)
	   (generate-svg board "board.svg")
	   (format t "Lisp: Board initialized.~%")
	   (format t "Player is ~a. AI is ~a (difficulty: ~a).~%" 
		   (string-downcase (symbol-name *player-color*))
		   (string-downcase (symbol-name *ai-color*))
		   (string-downcase (symbol-name *ai-difficulty*)))))
        
        ;; command 2: process move
	((string-equal command "move")
	 (when (>= (length args) 3)
	   (let* ((edge-to-cut (third args))
		  (human-color (if (>= (length args) 4) (fourth args) "blue"))
		  (loaded (load-state-values "board.dat"))
		  (current-board (first loaded))
		  (current-player (second loaded))
		  (move-number (third loaded)))
	     
	     ;; check if move is valid for current player
	     (let ((feedback (get-valid-move-feedback current-board edge-to-cut current-player)))
	       (if feedback
		   (format t "~a~%" feedback)  ; invalid move - no change of state
		   
		   ;; valid move - process it
		   (let* ((board-after-cut (remove-if (lambda (e) 
							(string-equal (edge-id e) edge-to-cut))
						      current-board))
			  (new-board (apply-gravity board-after-cut))
			  (next-player (switch-player current-player))
			  ;; GRAVITY FEEDBACK: find what is missing in the new board
			  (fallen-edges (remove-if (lambda (old-e)
						     (find (edge-id old-e) new-board :key #'edge-id :test #'string-equal))
						   board-after-cut))
			  (fallen-ids (mapcar #'edge-id fallen-edges)))
		     
		     ;; save new state
		     (save-state new-board "board.dat" 
				 :current-player next-player 
				 :move-number (1+ move-number))
		     
		     ;; generate new SVG
		     (generate-svg new-board "board.svg")
		     
		     ;; check for win
		     (let ((winner (check-win new-board current-player)))
		       (if winner
			   (format t "Game Over! ~a wins!~%" winner)
			   (progn
			     (format t "Cut edge ~a.~%" edge-to-cut)
			     (when fallen-ids
			       (format t "Gravity caused these edges to fall: ~{~a~^, ~}~%" fallen-ids))
			     (format t "~a's turn.~%" (string-downcase (symbol-name next-player)))
			     ;; Tell bash if AI should go next
			     (when (not (string-equal (string-downcase (symbol-name next-player)) human-color))
			       (format t "AI_TURN_NEXT~%")))))))))))
        
        ;; command 3: AI's turn
	((string-equal command "ai-turn")
	 (when (>= (length args) 4)
	   (let* ((human-color (third args))
		  (difficulty (fourth args))
		  (loaded (load-state-values "board.dat"))
		  (current-board (first loaded))
		  (current-player (second loaded))
		  (move-number (third loaded)))
	     
	     ;; call AI to calc move
	     (let ((edge-to-cut (ai-move current-board current-player difficulty)))
	       (if edge-to-cut
		   (let* ((board-after-cut (remove-if (lambda (e) 
							(string-equal (edge-id e) edge-to-cut))
						      current-board))
			  (new-board (apply-gravity board-after-cut))
			  (next-player (switch-player current-player))
			  ;; GRAVITY FEEDBACK: find what is missing in new board
			  (fallen-edges (remove-if (lambda (old-e)
						     (find (edge-id old-e) new-board :key #'edge-id :test #'string-equal))
						   board-after-cut))
			  (fallen-ids (mapcar #'edge-id fallen-edges)))
		     
		     ;; save new state
		     (save-state new-board "board.dat" 
				 :current-player next-player 
				 :move-number (1+ move-number))
		     
		     ;; generate new SVG
		     (generate-svg new-board "board.svg")
		     
		     ;; check for win
		     (let ((winner (check-win new-board current-player)))
		       (if winner
			   (format t "Game Over! ~a wins!~%" winner)
			   (progn
			     (format t "AI cuts edge ~a.~%" edge-to-cut)
			     (when fallen-ids
			       (format t "Gravity caused these edges to fall: ~{~a~^, ~}~%" fallen-ids))
			     (format t "~a's turn.~%" (string-downcase (symbol-name next-player)))))))
		   (format t "Game Over! AI has no moves!~%"))))))))))
```

**References:**
* Berlekamp, E. R., Conway, J. H., and Guy, R. K. (1982). *Winning Ways for your Mathematical Plays*, volumes 1 and 2. Academic Press, London.
* Conway, John H. (1976). *On Numbers and Games*. Academic Press. (LMS Monographs No. 6).