---
title: "DOMINEERING: The Geometry of Gridlock"
pubDatetime: 2026-08-10T00:00:00Z
description: "An exploration of Domineering, surreal numbers, and a complete implementation in bash and lisp."
author: "Jerod Michel, Gao Yucheng"
tags: ["bash", "lisp", "combinatorial game theory", "command line", "Domineering", "perfect information", "math"]
---

<blockquote class="text-right ml-auto max-w-2xl italic mb-8 !border-none !pl-0 before:content-none after:content-none [quotes:none]">
  <p>"In strategy the longest way round is often the shortest way there; a direct approach to the object exhausts the attacker and hardens the resistance by compression."</p>
  <p class="font-bold mt-2">— B.H. Liddell Hart, Strategy: The Indirect Approach (1941)</p>
</blockquote>

## Description

Domineering is a game of denial. Each domino placed not only claims territory; it poisons the squares around it, foreclosing entire classes of moves for an opponent while preserving one's own.

Having encountered our first partisan game of perfect information in Hackenbush, the reader will find that, where Hackenbush's partisanship was color-coded—blue for Left, red for Right, green for both—Domineering's partisanship is purely geometric.

This geometry will reveal a hidden structure: most positions are cold numbers, their value determining the winner regardless of who moves first. Some positions, however, still may offer the first player a decisive advantage. Understanding this—the temperature of the board—is key.

## History

When Swedish mathematician Göran Andersson invented the game around 1973, it wasn't called Domineering. It was introduced to the general public by renowned math communicator Martin Gardner in his November 1974 *Scientific American* column under the title *Crosscram*. Gardner's column, as always, sparked widespread interest among recreational mathematicians.

Once John Conway adopted the game as a textbook example for his emerging field of Combinatorial Game Theory, Domineering became famous for a remarkable property: a single game naturally breaks down during play into completely isolated, smaller sub-boards — what we now call a *disjunctive sum*. This decomposition allowed for the calculation of precise mathematical values for individual zones on the board, making Domineering a perfect laboratory for testing the nascent theory of surreal numbers.

In July 1994, the Mathematical Sciences Research Institute (MSRI) in Berkeley hosted a famous Domineering tournament featuring a $500 cash prize. Mathematician Dan Calistrate won the event on a standard $8 \times 8$ board, defeating David Wolfe in a final that became a case study in the early game-theory literature. The tournament demonstrated that Domineering was not merely a theoretical curiosity but a genuine competitive arena.

Because the board shrinks with every move, computer scientists soon began racing to solve the game using alpha-beta pruning and transposition tables. The results arrived in a steady march:

*   In 2000, Dennis Breuker, Jos Uiterwijk, and Jaap van den Herik solved the classic $8 \times 8$ board, proving it is a guaranteed win for the first player under perfect play.
*   In 2002, Nathan Bullock solved the $10 \times 10$ board as part of his academic thesis.
*   In 2016, Jos Uiterwijk pushed the boundaries of computing by solving the $11 \times 11$ board.

Computer mapping of these solved boards revealed something surprising in the game's mathematics. On almost all standard square layouts — $2 \times 2$, $3 \times 3$, $4 \times 4$, $6 \times 6$, $7 \times 7$, $8 \times 8$, $9 \times 9$, $10 \times 10$, and $11 \times 11$—the first player holds the advantage and wins under perfect play. However, the $5 \times 5$ board stands as an exception: it is a guaranteed win for the *second* player. This anomaly, an isolated island of second-player victory in a sea of first-player dominance, remains one of Domineering's most intriguing curiosities.

<div class="remark">

**Remark.**

The $5 \times 5$ exception is a reminder that in partisan games, symmetry is not always destiny. The geometry of the odd square, caught between the vertical and horizontal orientations, creates a perfect trap for the unwary first player — a gridlock of the highest order.

</div>

## Rules and Gameplay

Domineering is a two-player partisan game played on a rectangular grid of square cells. The players are *Left* (Vertical) and *Right* (Horizontal), each restricted to placing dominoes of a single orientation.

**The Board.** The game is played on a rectangular grid of square cells, typically of size $m \times n$. The board may be any finite rectangle. Initially, *every cell is empty*.

**Legal Moves.** A move consists of placing an (indivisible) domino covering two *adjacent empty cells*. Left may place a domino *vertically* over two cells that share a horizontal edge. Right may place a domino *horizontally* over two cells that share a vertical edge. Once a cell is covered, it remains occupied for the remainder of the game. No domino may overlap with another, and dominoes may not be moved or removed.

**Turn Order and Passing.** Players alternate moves. Left *traditionally moves first*, though this convention is not mathematically mandatory. *Passing is prohibited*: a player with at least one legal move must make one.

**Termination and Victory.** The game is *finite*: each move reduces the number of empty cells by exactly two. Play continues under the *normal play* convention: the player who makes the *final legal move wins*. If a player has *no legal move* on their turn, they lose immediately. *No draw* is possible.

## Mathematics of Domineering

### Partisan Games and the Need for Surreal Numbers

Having already encountered partisan games in Hackenbush, the reader will recall that not every game can be analyzed using the Sprague-Grundy theory. In impartial games such as Nim or Dawson's Kayles, the set of legal moves available to Left is identical to that available to Right. This symmetry allows us to assign a single nim-value to each position, and the outcome of a sum of games is determined by the nim-sum of their components.

Domineering has no such symmetry. Left may only place dominoes vertically and, Right, only horizontally. From a given position, Left's available moves are generally disjoint from Right's. A winning position for Left may be a losing one for Right, and vice versa. No *single* nim-value can capture this asymmetry.

To see why, consider a simple $2 \times 1$ vertical strip. Left can place exactly one vertical domino, leaving no empty cell (value $0$). Right then has no horizontal space to move. Thus, the value is
$$
\{0 \mid \} = 1.
$$


Symmetrically, a $1 \times 2$ horizontal strip has the value
$$
\{ \mid 0\} = -1.
$$


Now, consider the simplest nontrivial Domineering position: a $2 \times 2$ board. Left can place a vertical domino in either column. Either choice leaves a $2 \times 1$ vertical strip to the opponent, which we know evaluates to $1$. Thus, every Left option evaluates to $1$. Right, conversely, can place a horizontal domino in either row, each leaving a $1 \times 2$ horizontal strip with value $-1$. The $2 \times 2$ position then has value
$$
\{ 1 \mid -1 \}.
$$


Conway called this a *switch*, and denoted it $\pm 1$. It is a *hot game* where the first player to move has a clear advantage.

What if we alter the board slightly? Consider a 3-cell "L" tromino (a $2 \times 2$ board missing one corner). Left has exactly one vertical move, leaving a single isolated cell (value $0$). Right has exactly one horizontal move, also leaving a single isolated cell (value $0$). This position evaluates to
$$
\{ 0 \mid 0 \},
$$
which is exactly the nim-value $*1$ from impartial games. Domineering, being partisan, demands the richer arithmetic of surreal numbers to unify these disparate game types under one framework.

This example illustrates a central insight: Domineering positions are naturally represented as surreal numbers (or, more generally, *games*) in the sense of Conway. A position $P$ can be written as
$$
P = \{ P^L \mid P^R \},
$$
where $P^L$ ranges over all positions reachable from a single legal move by Left, and $P^R$ ranges over all positions reachable from a single legal move by Right. The value of $P$ is then determined recursively by the values of its options.

For a Domineering position $P$, let $\mathcal{L}(P)$ be the set of all positions obtained by a legal vertical move (by Left), and let $\mathcal{R}(P)$ be the set of all positions obtained by a legal horizontal move (by Right). Then the game value $P$ is defined recursively as
$$
G(P) = \{ G(Q) : Q \in \mathcal{L}(P) \mid G(R) : R \in \mathcal{R}(P) \}.
$$


This recursive definition is valid since every move reduces the number of empty cells by exactly two, ensuring well-foundedness. The terminal position—an empty board with no moves for either player—has value $\{ \mid \} = 0$.

In the sequel, we say that $G = \{ G^L \mid G^R \}$ is a *number* if:

1.  every Left option $G^L$ and every Right option $G^R$ are themselves numbers, and
2.  every Left option is strictly less than every Right option:
    $$
    G^L < G^R \quad \text{for all } L \in \mathcal{L}(G), R \in \mathcal{R}(G).
    $$
   

When this condition holds, by the Simplicity Rule established in the previous chapter, $G$ is the *simplest* number strictly between all Left options and all Right options.

As we have already seen in Hackenbush, the arithmetic of these values follows the rules of surreal numbers. Two positions are *equivalent* if their game values are equal in the surreal sense: $G \equiv H$ whenever $G - H$ is a zero game (or, a second-player win). The outcome of a position is determined by the sign of its value: positive values are a win for Left regardless of which player moves first; negative values are a win for Right; zero means the second player wins; and values that are confused with zero (such as $*$) indicate a first-player win.

Domineering, however, has a remarkable property regarding how a single game evolves: while the initial empty boards are *hot* (producing complex switches like $\pm 1$), the mid-to-late game rapidly fractures into isolated strips of $1 \times n$ and $m \times 1$. These independent parts are strictly integers and fractions, which distinguishes it from Blue-Red Hackenbush, which is composed entirely of numbers from the very first move. In the next subsection, we will prove this fundamental result and thereby justify the claim that its fragmented endgame is rigorously calculable.

<div class="remark">

**Remark.**

The phrase "cold" refers to positions whose values are numbers. Such positions are *cold* in the sense that neither player has an incentive to race there: the value of the position is already determined, and any move would only make it worse for the moving player. Hot positions, by contrast, are those where the first player has a decisive advantage—values that are not numbers, such as switches $\{a \mid b\}$ with $a > b$. Domineering's structural property tells us that while the early game is a fierce struggle for shared space (switches), the endgame collapses entirely into cold numbers.

</div>

### The Coldness Theorem

We now come to one of Domineering's most fundamental structural properties. Despite partisan asymmetry giving rise to hot switches such as $\{1 \mid -1\}$, the vast majority of Domineering positions are numbers in the surreal sense. This is a remarkable fact; it means that, for most positions, the winner is determined solely by the numerical value of the position, and not by whose turn it is.

<div class="theorem">

**Theorem (Algebraic Coldness).**

Let $P$ be any Domineering position. If every option of $P$ (both Left and Right) evaluates to a surreal number, and
$$
G(P^L) < G(P^R)
$$
holds for all Left options $P^L$ and Right options $P^R$, then $P$ itself evaluates to a number.

</div>

<div class="proof">

**Proof.**

Since $P$ is a finite position, the sets of legal moves $\mathcal{L}(P)$ and $\mathcal{R}(P)$ are finite. Therefore, we can identify the maximum value among Left's options and the minimum value among Right's options. Let
$$
l = \max_{P^L \in \mathcal{L}(P)} G(P^L) \quad \text{and} \quad r = \min_{P^R \in \mathcal{R}(P)} G(P^R)
$$
(If Left has no moves, we consider $l$ to be strictly less than $r$; symmetrically, if Right has no moves, $r$ is strictly greater than $l$).

By our hypothesis, the strict ordering condition holds, meaning $l < r$.

Since $l$ and $r$ are finite numbers (specifically integers or dyadic fractions), there must exist at least one number lying strictly between them—for example, their arithmetic mean $(l+r)/2$ is also a valid dyadic fraction. Let $x$ be the *simplest* such number (the number born on the earliest day in Conway's number tree) such that:
$$
l < x < r.
$$


Notice that $x$ fits strictly between all Left options and all Right options of $P$, and so it satisfies the exact conditions of the Simplicity Rule established in Chapter 6.

Therefore, by the Simplicity Rule, $G(P) = x$. Since $x$ is a number, the position $P$ evaluates to a number.
<div class="text-right">&#9633;</div>

</div>

The Coldness Theorem reduces the question of whether a position is a number to an algebraic check, but for an arbitrary Domineering position, this condition may fail—recall, for example, the $2 \times 2$ board with value $\{1 \mid -1\}$. However, as the game progresses and the board fractures into isolated strips, we are guaranteed the condition holds.

<div class="theorem">

**Corollary (Geometric Coldness).**

If a Domineering position $P$ consists entirely of isolated $1 \times n$ horizontal strips and $m \times 1$ vertical strips, then $P$ evaluates to a number.

</div>

<div class="proof">

**Proof.**

We proceed by induction on the number of empty cells in $P$.

**Base Case:** The empty board has no legal moves for either player, evaluating to $0$, which is a number.

**Inductive Hypothesis:** Assume the theorem holds for all positions having fewer empty cells than $P$.

Notice that any move from $P$ preserves the property of being a collection of isolated strips, so that all options of $P$ must be numbers by the inductive hypothesis.

It remains to verify the ordering condition. Let $P^L$ be a Left option (resulting from a vertical move $V$) and $P^R$ be a Right option (resulting from a horizontal move $H$). Since $P$ consists strictly of isolated $1 \times n$ and $m \times 1$ strips, Left can play legally only within the vertical strips, and Right only within the horizontal strips. Thus, their placements occupy completely disjoint regions and strictly commute. Right can still play the horizontal domino on $P^L$, and Left can still play the vertical domino on $P^R$, both resulting in the exact same position $P_{V,H}$.

Since $P^L$ is a number and $P_{V,H}$ is a Right option of $P^L$, we have that $G(P^L) < G(P_{V,H})$. Since $P^R$ is a number and $P_{V,H}$ is a Left option of $P^R$, we have $G(P_{V,H}) < G(P^R)$. By transitivity, $G(P^L) < G(P^R)$. Thus the ordering condition holds for all pairs of options.

By the Algebraic Coldness Theorem, $P$ must evaluate to a number.
<div class="text-right">&#9633;</div>

</div>

<div class="remark">

**Remark.**

The Geometric Coldness Corollary is the heart of Domineering's endgame theory. While the early game may be hot—contested regions where vertical and horizontal moves compete for the same cells—the late game inevitably fragments into isolated strips. Once this fragmentation occurs, all remaining positions are cold numbers, and the winner is determined solely by the sum of their values. This is why Domineering, despite its partisan origins, is ultimately a game of calculation.

</div>

### Values of Small Rectangles

With the Coldness Theorem at hand we can now compute exact values for several fundamental positions. These values will serve as building blocks for larger boards and for evaluating endgame positions.

#### The $1 \times n$ Strip

The simplest family of positions are the $1 \times n$ strips—a single row of $n$ cells. On such a strip, Right (horizontal) can place a domino covering any two adjacent cells. Left (vertical) has no legal moves since there is only one row.

Let $V_n$ denote the value of a $1 \times n$ strip. The following are clear:

*   $V_0 = 0$ (empty board).
*   $V_1 = 0$ (a single isolated cell; no moves for either player).
*   $V_2 = \{\mid 0\} = -1$ (Right has one horizontal move, leaving an empty board).

Notice that on a $1 \times 3$ strip Right can place a horizontal domino into one of two positions. Covering the first two cells leaves one isolated cell, giving a value of $0$. Similarly, covering the last two cells gives a value of $0$. Since Left still has no legal move, the game evaluates simply to:
$$
V_3 = \{ \mid 0 \} = -1.
$$


This pattern holds in general. In a $1 \times n$ strip, Left has no move. Right can place exactly $\lfloor n/2 \rfloor$ dominoes before running out of space, regardless of strategy, as Left is incapable of interfering. Therefore, the horizontal strip is simply a number of free moves granted to Right that is equal to the maximum number of horizontal dominoes that will fit.

The value, then, of any $1 \times n$ horizontal strip is given by:
$$
G(1 \times n) = -\lfloor n/2 \rfloor.
$$


Similarly, as an $m \times 1$ vertical strip grants free moves exclusively to Left, we have:
$$
G(m \times 1) = \lfloor m/2 \rfloor.
$$


#### The $2 \times n$ Sequence

Expanding to a width of two introduces shared space and significantly complicates calculation, as moves now conflict. We have already established the values for small iterations:
$$
\begin{align*}
G(2 \times 1) &= 1, \\
G(2 \times 2) &= \{1 \mid -1\} = \pm 1.
\end{align*}
$$


The $2 \times 2$ board, then, is our first hot game, but what happens when we extend the strip to $2 \times 3$? Left then has two types of vertical moves:
*   playing on either end, which leaves a $2 \times 2$ block (value $\pm 1$), or
*   playing in the center, which leaves two isolated $2 \times 1$ strips (value $1 + 1 = 2$).

Right's horizontal moves each leave an asymmetric $4$-cell L-shape (a $2 \times 3$ board missing a $1 \times 2$ corner). Evaluating this subgame, we have Left's only move leaving a $1 \times 2$ horizontal strip, while Right's best move leaves isolated cells. Thus, the L-shape evaluates to $\{-1 \mid 0\} = -1/2$.

Since Left prefers $2$ over $\pm 1$, the optimal moves for the $2 \times 3$ board give:
$$
G(2 \times 3) = \left\{ 2 \mathrel{\Big|} -\frac{1}{2} \right\}.
$$


Notice that Left's option (evaluating to $2$) is greater than Right's option (evaluating to $-1/2$). Since these options overlap algebraically, the Simplicity Rule cannot apply. Therefore, the position is not a number; it remains a hot switch.

#### The $3 \times 3$ Board

Since the $2 \times 3$ board escalated the conflict, one might expect the $3 \times 3$ board to be hotter still. However, offering more shared space in both dimensions actually diffuses some tension.

Notice that the symmetry reduces Left's choices to just two essentially distinct vertical moves: playing in an outer column, or playing in the middle column. If Left plays in an outer column, it leaves a massive contiguous block of empty cells for Right.

However, if Left plays in the *center* column (covering, say, the top two cells), the domino acts as a wall. It bisects the upper portion of the board, completely severing Right's ability to play across the top two rows, while simultaneously preserving two vertical columns for its own use.

Evaluating this strategically bisected subgame yields a value of exactly $1/2$. By symmetry, Right's best move (playing horizontally in the middle row) evaluates to $-1/2$. Thus, the board evaluates to:
$$
G(3 \times 3) = \left\{ \frac{1}{2} \mathrel{\Big|} -\frac{1}{2} \right\}.
$$


This is a switch, but cooler than both the $2 \times 2$ board's $\{1 \mid -1\}$ and the highly volatile $2 \times 3$ board. The first player to move on a $3 \times 3$ board secures an advantage of $\frac{1}{2}$, whereas moving on a $2 \times 2$ board secures a full move advantage.

We call this advantage the *temperature*. The $2 \times 2$ board has a temperature of $1$, the $3 \times 3$ board has a temperature of $1/2$, and the hotter $2 \times 3$ board reaches a temperature of $5/4$. When analyzing complex positions, evaluating the temperature of such isolated subgames allows us to determine the urgency of playing in them.

### The $5 \times 5$ Anomaly

As we mentioned earlier, square boards almost universally favor the first player. The intuition is straightforward: on a highly contested, symmetric grid, the player who places the first domino establishes the initial temperature, and dictates the pace of the game's fragmentation.

However, the $5 \times 5$ board stands out as singular. Despite the first player's initiative, the $5 \times 5$ board ends up a guaranteed win for the *second* player. Mathematically, it evaluates exactly to a zero game:
$$
G(5 \times 5) = 0.
$$


To understand why this board is an exception, we consider a symmetric pairing strategy.

Since a square board is symmetric across its main diagonal, there exists a natural mapping between Left's vertical moves and Right's horizontal moves. If we label cells using coordinates $(x,y)$, we can see there is a mapping where each cell $(x,y)$ is sent to the cell $(y,x)$. Consequently, a vertical domino covering $(x,y)$ and $(x, y+1)$ reflects perfectly into a horizontal domino covering $(y,x)$ and $(y+1, x)$.

The symmetry across the diagonal guarantees Right has a response to any off-diagonal move by Left. If this pairing held universally, Right would inevitably make the last move, securing a second-player win on *any* square board. The strategy breaks down, however, when players do play on the diagonal.

Any domino intersecting the main diagonal covers exactly one diagonal cell and one off-diagonal cell. If Left places a vertical domino covering, for example, $(3,3)$ and $(2,3)$, the "reflected" horizontal domino should cover $(3,3)$ and $(3,2)$. Since these two dominoes overlap at $(3,3)$, Right cannot strictly mirror moves intersecting the diagonal. A rational first player, then, will play on the diagonal to disrupt Right's pairing strategy.

Coming back to the anomaly, on a $5 \times 5$ board, the main diagonal consists of exactly $5$ cells. Since each domino intersecting the diagonal consumes exactly one diagonal cell, there can be a maximum of $5$ such disrupting moves in the entire game, limiting Left's capacity to break this pairing strategy.

Exhaustive game-tree searches [Breuker00, Bullock02] have confirmed that Left simply does not have enough diagonal space to overcome Right's relentless mirroring. Right can absorb Left's limited diagonal disruptions, adjust their pairing, and inevitably exhaust Left's moves.

### Disjunctive Sums and Endgame Evaluation

As we saw in Chapter 6, positions that fracture into independent components form a disjunctive sum. The value of such a sum is the sum of its components computed in the surreal sense.

This additivity is the engine that makes Domineering's endgame tractable. Once the board has fractured into isolated strips, the value of each strip can be computed independently and then summed disjunctively.

Consider, for example, a position consisting of two isolated $1 \times 2$ horizontal strips. Each has value $-1$, so the total value is
$$
(-1) + (-1) = -2.
$$


This means Right has two free moves; Left has none. Right will win regardless of who moves first.

A more interesting example is a $2 \times 2$ board (value $\pm 1$) placed alongside an isolated $1 \times 2$ horizontal strip (value $-1$). By the rules of addition for surreal games, the cold number is added directly to the options of the hot switch:
$$
\pm 1 - 1 = \{1 - 1 \mid -1 - 1\} = \{0 \mid -2\}.
$$


This position is still a hot game, but notice what has happened. The temperature remains exactly $1$ (since half the difference between $0$ and $-2$ is still $1$), meaning the urgency to play in the $2 \times 2$ component has not changed. However, the *mean value* has shifted from $0$ to $-1$. The cold component has not cooled the game down; rather, it has shifted the entire battleground into Right's territory.

### Computational Complexity

Despite the elegant mathematical structure of the endgame, determining the winner from an arbitrary position is computationally intractable. Domineering is known to be PSPACE-complete, even on boards of dimension $n \times n$ [Lachmann00].

This means that no polynomial-time algorithm is known (or expected) to solve Domineering in general. The game tree grows exponentially with the board size, and the partisan nature of the game prevents simpler nim-sum analyses that work for impartial games.

Such complexity justifies the use of search algorithms for larger boards. While the theory gives us exact values for isolated strips and small rectangles, arbitrary positions will require computational exploration. The search algorithms presented in the following section---using alpha-beta pruning and transposition tables---are the practical tools that bring the mathematics to life.

<div class="remark">

**Remark.**

The PSPACE-completeness of Domineering is one of its most fascinating features. Despite being "mostly cold", the problem of determining the winner remains hard in the worst case. This tension between mathematical tractability in the endgame and computational intractability in general has been a recurring theme in combinatorial game theory.

</div>

## Example of Gameplay

To illustrate the mathematical principles developed in this chapter, we walk through a concrete position. Consider the $4 \times 4$ board shown in Figure 1, with several cells already occupied.

![Figure 1: A mid-game Domineering position. Occupied cells are greyed out. The remaining empty cells have fragmented into four isolated components: a 2x2 block (blue), a 1x2 horizontal strip (red), a 2x1 vertical strip (green), and a 1x1 isolated cell (yellow).](/domineer0.png)

The total value of the position is the sum of its components:
$$
G = \pm 1 + (-1) + 1 + 0 = \pm 1.
$$


This is a hot game: the first player to move will win by playing in the $2 \times 2$ block. The cold components (whose values are $-1$, $1$, and $0$) simply shift the mean value without affecting the temperature.

We now walk through optimal play.

### Move 1: Left's Opening

Left (vertical) correctly identifies the $2 \times 2$ block as the only hot component. Left plays a vertical domino in the $2 \times 2$ block, leaving a $2 \times 1$ vertical strip (value $1$). The board now has value:
$$
1 + (-1) + 1 + 0 = 1.
$$


The position is now a number (cold), with value $1$, and Left has secured the advantage.

### Move 2: Right's Response

Right (horizontal) now has no hot move. Right plays a horizontal domino in the $1 \times 2$ strip, and the board value becomes:
$$
1 + 1 + 0 = 2.
$$


### Move 3: Left's Response

Left plays in one of the $2 \times 1$ remaining vertical strips, leaving one of the vertical strips, and the $1 \times 1$ isolated cell. The value becomes:
$$
0 + 1 = 1.
$$


### Move 4: Right's Response

Right now has no legal move as the only remaining components are the $2 \times 1$ vertical strip, and the isolated cell.

Thus, Right has no legal moves and (under normal play) Left wins.

<div class="remark">

**Remark.**

This example demonstrates the key strategic insight of Domineering: identify hot components and play in them first. Cold components can be safely ignored until the hot components are resolved. The arithmetic of surreal numbers provides the exact calculations justifying this strategy.

</div>

## Domineering in Command Line (with Lisp for game engines)

### Algorithmic Application: Minimax in a Partisan Context

The minimax algorithm and alpha-beta pruning were established in the Chapter 4. While the underlying tree-search mechanism remains identical, Domineering requires a conceptual shift in how we evaluate game states and generate branches due to its partisan nature.

Unlike impartial games where both players share the same available moves, Domineering assigns mutually exclusive move sets where Left (vertical) places $2 \times 1$ dominoes, and Right (horizontal) places $1 \times 2$ dominoes. The minimax architecture handles this asymmetry elegantly. The maximizing player strictly evaluates the board state generating vertical moves, while the minimizing player strictly evaluates horizontal moves.

To navigate the game tree effectively, our alpha-beta implementation relies on a specific evaluation function:

*   **Mobility Heuristic:** Instead of counting discrete points or boxes, the evaluation function calculates the difference in available legal moves. If $V$ is the number of valid vertical moves and $H$ is the number of valid horizontal moves, the board value for Left is $V - H$.
*   **Zero-Sum Dynamics:** Every domino placed by Left consumes two squares. This may simultaneously reduce $V$ (by taking up vertical space) and reduce $H$ (by blocking horizontal placements). The AI seeks moves that maximize the destruction of the opponent's move space while preserving its own.

<div class="example">

**Example (Pruning in Domineering).**

Consider a position where Left (maximizer) has found a move sequence that guarantees a mobility advantage of +2 ($\alpha = 2$). If Right (minimizer) evaluates a response branch that immediately drops Left's mobility advantage to 0 ($\beta = 0$), then $\beta \leq \alpha$. The algorithm mathematically proves that the maximizer would never willingly choose a path leading to this branch, allowing the engine to prune the remaining horizontal responses without calculating their terminal states.

</div>

### Architectural Overview

Our Domineering implementation maintains a hybrid scripting architecture, customized for real-time visual output:

*   **Bash (Game Orchestration):** Manages the terminal interface, controls the game loop, and handles the continuous rendering of the board state to a standalone SVG viewer.
*   **Common Lisp (The Engine):** Receives board dimensions and difficulty parameters to execute the core game logic.
*   **Strategic Foundation:** The AI utilizes:
    *   Move validation and asymmetric move generation.
    *   State manipulation via `apply-move` and `undo-move` to traverse the game tree without duplicating the board array in memory.
    *   Alpha-beta pruning recursively projecting game states up to a depth of $d=5$ (note that this is set by default to $d=3$), dynamically evaluating mobility to force the opponent into starvation.

<div class="remark">

**Remark (Practical Implementation).**

Since an $8 \times 8$ board begins with a rapidly decaying but high branching factor, the alpha-beta search is critical. Without pruning, a depth-5 search on an open board would require evaluating millions of permutations, causing significant computational latency. By pruning suboptimal sub-trees early, the engine is able to calculate advanced, game-ending spatial traps in milliseconds.

</div>

### Game Orchestration (Bash)

The Bash component manages the user interface (where input is command line and output is an svg file) and menus where the player may make such choices as diffilculty level, board size, etc.

```bash
#!/bin/bash
cd "$(dirname "$0")" || exit 1

# ANSI Color Codes
BLUE='\033[1;34m'
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
NC='\033[0m' # No Color

# initial State
BOARD_SIZE=5
DIFFICULTY="Medium"
SEARCH_DEPTH="1"
PLAYER_TURN="First" # options: First, Second, Random

# clear screen function
clear_screen() {
    printf "\033c"
}

# print the header
print_header() {
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${CYAN}       D O M I N E E R I N G             ${NC}"
    echo -e "${CYAN}=========================================${NC}"
    echo -e "Board Size: ${YELLOW}${BOARD_SIZE}x${BOARD_SIZE}${NC} | Difficulty: ${YELLOW}${DIFFICULTY}${NC} (Depth ${SEARCH_DEPTH})"
    echo -e "Human Plays: ${YELLOW}${PLAYER_TURN}${NC}"
    echo -e "${CYAN}-----------------------------------------${NC}"
}

# launch game
start_game() {
    clear_screen
    echo -e "${GREEN}Initializing Lisp Engine...${NC}"
    echo -e "Starting ${BOARD_SIZE}x${BOARD_SIZE} board at Depth ${SEARCH_DEPTH}."
    echo -e "Watch the eog window for the board state!\n"
    
    # touch SVG file so eog can open immediately
    rm -f current_board.svg
    touch current_board.svg
    
    # launch eog in background. (eog auto-reloads when file changes)
    eog current_board.svg > eog_error.log 2>&1 &
    EOG_PID=$!

    # translate ACTUAL_TURN string into numeric human player ID
    HUMAN_PLAYER=1
    if [ "$ACTUAL_TURN" == "Second" ]; then
        HUMAN_PLAYER=2
    fi

    # translate DIFFICULTY string to numeric ID (1=Easy, 2=Medium, 3=Hard)
    DIFF_NUM=2
    if [ "$DIFFICULTY" == "Easy" ]; then DIFF_NUM=1; fi
    if [ "$DIFFICULTY" == "Hard" ]; then DIFF_NUM=3; fi

    # Left (Player 1) ALWAYS makes first move
    START_PLAYER=1

    # pass control to Lisp engine
    echo -e "${YELLOW}Enter your moves as two coordinates (e.g., C2 C3).${NC}"
    echo -e "${YELLOW}Press Ctrl+D when you are ready to end the game.${NC}\n"
    
    # pass ALL 4 argumehnts to Lisp engine
    sbcl --script domineering-engine.lisp $BOARD_SIZE $START_PLAYER $DIFF_NUM $HUMAN_PLAYER 2> engine_error.log
    
    # when Lisp engine exits (via Ctrl+D or game over), kill eog viewer
    kill $EOG_PID 2>/dev/null
    
    echo -e "\n${GREEN}Game Over!${NC}"
    # pause and wait for user to hit Enter before clearing screen
    read -p "Press Enter to return to the main menu..."
    
    sleep 2
}

# main menu loop
while true; do
    clear_screen
    print_header
    echo "1) Start Game"
    echo "2) Set Board Size"
    echo "3) Set Difficulty"
    echo "4) Set Player Turn"
    echo "5) Exit"
    echo -e "${CYAN}-----------------------------------------${NC}"
    read -p "Select an option [1-5]: " choice

    case $choice in
        1)
            # handle random coin flip right before start
            ACTUAL_TURN=$PLAYER_TURN
            if [ "$ACTUAL_TURN" == "Random" ]; then
                if [ $((RANDOM % 2)) -eq 0 ]; then
                    ACTUAL_TURN="First"
                else
                    ACTUAL_TURN="Second"
                fi
                echo -e "${GREEN}Random selection: You are going ${ACTUAL_TURN}!${NC}"
                sleep 2
            fi
            
            # pass $ACTUAL_TURN to start_game function/Lisp engine here
            start_game
            ;;
        2)
            echo -e "\n${YELLOW}Select Board Size:${NC}"
            echo "1) 5x5 (The Anomaly)"
            echo "2) 6x6"
            echo "3) 8x8"
            read -p "Choice [1-3]: " size_choice
            case $size_choice in
                1) BOARD_SIZE=5 ;;
                2) BOARD_SIZE=6 ;;
                3) BOARD_SIZE=8 ;;
            esac
            ;;
        3)
            echo -e "\n${YELLOW}Select Difficulty:${NC}"
            echo "1) Easy   (Random)"
            echo "2) Medium (1-Move Lookahead)"
            echo "3) Hard   (Depth 3)"
            read -p "Choice [1-3]: " diff_choice
            case $diff_choice in
                1) DIFFICULTY="Easy"; SEARCH_DEPTH="N/A" ;;
                2) DIFFICULTY="Medium"; SEARCH_DEPTH="1" ;;
                3) DIFFICULTY="Hard"; SEARCH_DEPTH="3" ;;
            esac
            ;;
        4)
            echo -e "\n${YELLOW}Select Who Goes First:${NC}"
            echo "1) Human goes First (Left/Vertical)"
            echo "2) Human goes Second (Right/Horizontal)"
            echo "3) Randomize"
            read -p "Choice [1-3]: " turn_choice
            case $turn_choice in
                1) PLAYER_TURN="First" ;;
                2) PLAYER_TURN="Second" ;;
                3) PLAYER_TURN="Random" ;;
            esac
            ;;
        5)
            echo -e "${GREEN}Exiting. Goodbye!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option.${NC}"
            sleep 1
            ;;
    esac
done
```

### AI Engine (Common Lisp)

The Lisp component handles game flow, state managemant, the building of boards, and the strategic AI using the minimax algorithm with alpha-beta pruning.

```lisp
;;; domineering-engine.lisp
;;; run with: sbcl --script domineering-engine.lisp [SIZE] [START] [DIFF] [HUMAN]

(defparameter *cell-size* 60)
(defparameter *offset* 40)
(defparameter *board* nil)
(defparameter *rows* 0)
(defparameter *cols* 0)

(defun init-board (r c)
  (setf *rows* r
        *cols* c
        *board* (make-array (list r c) :initial-element 0)))

(defun get-color (val)
  (case val
    (0 "#ffffff") ; Empty
    (1 "#6464ff") ; Left (Blue)
    (2 "#ff6464") ; Right (Red)
    (t "#cccccc")))

(defun draw-svg-board (filename &optional game-over-msg)
  "Builds SVG, writes to temp file, and uses native SBCL mv for atomic updates."
  (let* ((padding 15)
         (width (+ *offset* (* *cols* *cell-size*) padding))
         (height (+ *offset* (* *rows* *cell-size*) padding))
         (temp-filename (concatenate 'string filename ".tmp"))
         (svg-data
          (with-output-to-string (stream)
            (format stream "<svg xmlns='http://www.w3.org/2000/svg' width='~A' height='~A'>~%" width height)
            (format stream "<style>text { font-family: monospace; font-size: 18px; text-anchor: middle; dominant-baseline: middle; fill: #333; }</style>~%")
            (format stream "<rect width='100%' height='100%' fill='#ffffff'/>~%")
            
            (dotimes (c *cols*)
              (let ((char-label (code-char (+ (char-code #\A) c)))
                    (x (+ *offset* (* c *cell-size*) (/ *cell-size* 2)))
                    (y (/ *offset* 2)))
                (format stream "<text x='~A' y='~A'>~A</text>~%" x y char-label)))
                
            (dotimes (r *rows*)
              (let ((x (/ *offset* 2))
                    (y (+ *offset* (* r *cell-size*) (/ *cell-size* 2))))
                (format stream "<text x='~A' y='~A'>~A</text>~%" x y (1+ r))))
                
            (dotimes (r *rows*)
              (dotimes (c *cols*)
                (let ((val (aref *board* r c))
                      (x (+ *offset* (* c *cell-size*)))
                      (y (+ *offset* (* r *cell-size*))))
                  (format stream "<rect x='~A' y='~A' width='~A' height='~A' fill='~A' stroke='#333' stroke-width='2'/>~%"
                          x y *cell-size* *cell-size* (get-color val)))))
            
            (when game-over-msg
              (let ((box-w 280) (box-h 60))
                (format stream "<rect x='~A' y='~A' width='~A' height='~A' fill='black' opacity='0.85' rx='8'/>~%" 
                        (- (/ width 2) (/ box-w 2)) (- (/ height 2) (/ box-h 2)) box-w box-h)
                (format stream "<text x='~A' y='~A' font-size='22' fill='white' font-weight='bold'>~A</text>~%" 
                        (/ width 2) (+ (/ height 2) 2) game-over-msg)))
            
            (format stream "</svg>~%"))))

    ;; 1. write fully complete SVG to temporary file
    (with-open-file (out temp-filename :direction :output :if-exists :supersede :if-does-not-exist :create)
      (write-string svg-data out))
    
    ;; 2. atomic rename using SBCL's native program runner
    (sb-ext:run-program "mv" (list temp-filename filename) :search t)))

;;; ==========================================
;;; AI OPPONENT LOGIC
;;; ==========================================
(setf *random-state* (make-random-state t))

(defun get-valid-moves (player)
  (let ((moves nil))
    (dotimes (r *rows*)
      (dotimes (c *cols*)
        (if (= player 1)
            (when (valid-move-p r c (1+ r) c player)
              (push (list r c (1+ r) c) moves))
            (when (valid-move-p r c r (1+ c) player)
              (push (list r c r (1+ c)) moves)))))
    moves))

(defun apply-move (move player)
  (setf (aref *board* (first move) (second move)) player)
  (setf (aref *board* (third move) (fourth move)) player))

(defun undo-move (move)
  (setf (aref *board* (first move) (second move)) 0)
  (setf (aref *board* (third move) (fourth move)) 0))

(defun format-move (move)
  (let ((c1-char (code-char (+ (second move) (char-code #\A))))
        (r1-num (1+ (first move)))
        (c2-char (code-char (+ (fourth move) (char-code #\A))))
        (r2-num (1+ (third move))))
    (format nil "~A~A ~A~A" c1-char r1-num c2-char r2-num)))

(defun easy-ai-move (player)
  (let ((moves (get-valid-moves player)))
    (when moves (nth (random (length moves)) moves))))

(defun evaluate-mobility (player)
  (let ((opponent (if (= player 1) 2 1)))
    (- (length (get-valid-moves player))
       (length (get-valid-moves opponent)))))

(defun medium-ai-move (player)
  (let ((moves (get-valid-moves player))
        (best-score -9999)
        (best-moves nil))
    (dolist (m moves)
      (apply-move m player)
      (let ((score (evaluate-mobility player)))
        (undo-move m)
        (cond ((> score best-score)
               (setf best-score score)
               (setf best-moves (list m)))
              ((= score best-score)
               (push m best-moves)))))
    (when best-moves (nth (random (length best-moves)) best-moves))))

;; --- PASTE THE NEW CODES HERE ---

(defun alpha-beta-search (depth current-player alpha beta ai-player)
  "Recursive Alpha-Beta evaluation. Tracks the board state relative to ai-player."
  (let ((moves (get-valid-moves current-player)))
    (cond 
      ((or (= depth 0) (null moves))
       (evaluate-mobility ai-player))
      ((= current-player ai-player)
       (let ((max-eval -9999))
         (dolist (m moves max-eval)
           (apply-move m current-player)
           (let ((score (alpha-beta-search (1- depth) 
                                           (if (= current-player 1) 2 1) 
                                           alpha beta ai-player)))
             (undo-move m)
             (setf max-eval (max max-eval score))
             (setf alpha (max alpha score))
             (when (>= alpha beta)
               (return max-eval))))))
      (t
       (let ((min-eval 9999))
         (dolist (m moves min-eval)
           (apply-move m current-player)
           (let ((score (alpha-beta-search (1- depth) 
                                           (if (= current-player 1) 2 1) 
                                           alpha beta ai-player)))
             (undo-move m)
             (setf min-eval (min min-eval score))
             (setf beta (min beta score))
             (when (>= alpha beta)
               (return min-eval)))))))))

(defun hard-ai-move (player)
  "Advanced AI choice using standard alpha-beta pruning lookahead."
  (let ((moves (get-valid-moves player))
        (best-score -9999)
        (best-moves nil)
        (search-depth 3)) 
    (dolist (m moves)
      (apply-move m player)
      (let ((score (alpha-beta-search (1- search-depth) 
                                      (if (= player 1) 2 1) 
                                      -9999 9999 player)))
        (undo-move m)
        (cond ((> score best-score)
               (setf best-score score)
               (setf best-moves (list m)))
              ((= score best-score)
               (push m best-moves)))))
    (when best-moves (nth (random (length best-moves)) best-moves))))

;;; ==========================================
;;; PARSER AND GAME LOOP
;;; ==========================================
(defun parse-coord (coord-str)
  (let* ((coord (string-trim " " (string-upcase coord-str)))
         (col-char (char coord 0))
         (col (- (char-code col-char) (char-code #\A)))
         (row-str (subseq coord 1))
         (row (1- (parse-integer row-str))))
    (list row col)))

(defun valid-move-p (r1 c1 r2 c2 player)
  (and (>= r1 0) (< r1 *rows*) (>= c1 0) (< c1 *cols*)
       (>= r2 0) (< r2 *rows*) (>= c2 0) (< c2 *cols*)
       (= (aref *board* r1 c1) 0)
       (= (aref *board* r2 c2) 0)
       (if (= player 1) 
           (and (= c1 c2) (= (abs (- r1 r2)) 1))
           (and (= r1 r2) (= (abs (- c1 c2)) 1)))))

(defun process-move (input-string player)
  (handler-case
      (let* ((clean-input (string-trim " " input-string))
             (space-pos (position #\Space clean-input)))
        (if (not space-pos)
            (format t "ERROR: Need two coordinates separated by a space (e.g., A1 A2).~%")
            (let* ((coord1 (subseq clean-input 0 space-pos))
                   (coord2 (subseq clean-input (1+ space-pos)))
                   (pos1 (parse-coord coord1))
                   (pos2 (parse-coord coord2))
                   (r1 (first pos1)) (c1 (second pos1))
                   (r2 (first pos2)) (c2 (second pos2)))
              (if (valid-move-p r1 c1 r2 c2 player)
                  (progn
                    (setf (aref *board* r1 c1) player)
                    (setf (aref *board* r2 c2) player)
                    (format t "SUCCESS~%"))
                  (format t "ERROR: Invalid move. Check rules and bounds.~%")))))
    (error (c)
      (format t "ERROR: Syntax not recognized. Try exactly A1 A2.~%"))))

(defun main-loop (size starting-player difficulty human-player)
  (init-board size size)
  (draw-svg-board "current_board.svg")
  
  (let ((current-player starting-player))
    (loop
      (finish-output)
      
      ;; WIN CONDITION CHECK
      (unless (get-valid-moves current-player)
        (let ((msg (if (= current-player human-player) "GAME OVER: AI WINS" "GAME OVER: YOU WIN")))
          (draw-svg-board "current_board.svg" msg)
          (format t "~%>>> ~A <<<~%" msg)
          (finish-output)
          (sleep 3)
          (sb-ext:exit :code 0)))
      
      ;; TAKE TURN
      (if (and (> difficulty 0) (/= current-player human-player))
          (progn
            (let ((move (cond ((= difficulty 1) (easy-ai-move current-player))
                              ((= difficulty 2) (medium-ai-move current-player))
                              ((= difficulty 3) (hard-ai-move current-player)))))
              (apply-move move current-player)
              (draw-svg-board "current_board.svg")
              (sleep 0.1) ; <--- ADDED: Gives eog time to render AI move
              (format t "~%>>> AI played: ~A~%" (format-move move))
              (setf current-player (if (= current-player 1) 2 1))))
          
          (progn
            ;; HUMAN PROMPT
            (format t "~%Your turn (~A) [e.g. A1 A2]: " (if (= current-player 1) "Blue/Vertical" "Red/Horizontal"))
            (finish-output)
            
            (let ((input (read-line nil nil :eof)))
              (when (eq input :eof) (return))
              (let ((result (with-output-to-string (*standard-output*)
                              (process-move input current-player))))
                (if (search "SUCCESS" result)
                    (progn
                      (draw-svg-board "current_board.svg")
                      (sleep 0.1) ; <--- ADDED: Gives eog time to render Human move
                      (setf current-player (if (= current-player 1) 2 1)))
                    (format t "~A" result)))))))))

;;; ==========================================
;;; SCRIPT ENTRY POINT
;;; ==========================================
(let ((args sb-ext:*posix-argv*))
  (if (>= (length args) 5)
      (let ((size (parse-integer (nth 1 args)))
            (start-player (parse-integer (nth 2 args)))
            (difficulty (parse-integer (nth 3 args)))
            (human-player (parse-integer (nth 4 args))))
        (main-loop size start-player difficulty human-player))
      (format t "ERROR: Missing args. Expected: size start_player difficulty human_player~%")))
```

**References:**
* Berlekamp, E. R., Conway, J. H., and Guy, R. K. (1982). *Winning Ways for your Mathematical Plays*, volumes 1 and 2. Academic Press, London.
* Breuker, D. M., Uiterwijk, J. W. H. M., and van den Herik, H. J. (2000). Solving $8 \times 8$ Domineering. *Theoretical Computer Science*, 230(1-2):195–206.
* Bullock, N. (2002). *Domineering: Solving Large Combinatorial Search Spaces*. Master's thesis, University of Alberta.
* Lachmann, M., Moore, C., and Rapaport, I. (2000). Who wins Domineering is PSPACE-complete. *Theoretical Computer Science*, 246(1-2):283–300.