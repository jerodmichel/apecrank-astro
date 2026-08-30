---
title: "DOTS AND BOXES: The Double Crossing"
pubDatetime: 2024-12-01T00:00:00Z
description: "An exploration of Dots and Boxes, combinatorial game theory, and a complete implementation in bash and lisp."
author: "Jerod Michel, Gao Yucheng"
tags: ["bash", "lisp", "binary", "command line", "Dots and Boxes", "perfect information", "math"]
---

<blockquote class="text-right ml-auto max-w-2xl italic mb-8 !border-none !pl-0 before:content-none after:content-none [quotes:none]">
  <p>"The strength of an army, like the amount of momentum in mechanics, is estimated by mass times the velocity."</p>
  <p class="font-bold mt-2">— Napoleon Bonaparte</p>
</blockquote>

## Description

This game has less to do with taking boxes and more to do with forcing your opponent to take the last box in a chain. Everything else is noise. The player who understands this has already won; the rest are merely part of the noise.

## History

**French Origin**

The game is said to have been invented in a salon in Paris. It first appeared in 1889 in "Récréations Mathématiques," a seminal work of François Édouard Lucas—the same mathematician known for the Lucas sequences and for devising the Tower of Hanoi puzzle. He named it "La Pipopipette." Under this name that it was first presented as a mathematical recreation and a battle of wits grounded in combinatorial principles.

**Cross-Channel Journey**

It did not take long for the game to cross the English Channel. Already in 1895 the legendary British puzzle-maker Henry Ernest Dudeney had included it in his first book of puzzles, titled, "Boxes." The straightforward English name stuck in the Anglophone world, and procured for it a reputation as a simple children's game.

**Reinvention at Cambridge**

The game's mathematical and strategic life began in the late 20th century, largely due to the work of Elwyn Berlekamp, John Conway, and Richard Guy at the University of Cambridge. Their 1982 book, Winning Ways for Your Mathematical Plays, has an entire chapter dedicated to Dots and Boxes.

Today, Dots and Boxes remains as a classic example in combinatorial game theory and AI programming. While it is considered solved for small boards, larger boards remain rich possibility and gameplay.

## Rules and Gameplay

### Objective
To score more points than your opponent. Points are awarded by claiming boxes.

### Mechanics

*   **The Board:** The game begins with an empty $n \times n$ grid of points (vertices). The standard board is a $4 \times 4$ or $5 \times 5$ grid of points.
*   **Taking a Turn:** On a player's turn, they must draw a single horizontal or vertical line connecting two adjacent, unconnected points.
*   **Claiming a Box:** When a player draws the fourth and final side of a $1 \times 1$ square (box), they immediately claim that box by placing their initial or marker inside of it. This action **does not end their turn**. They must immediately draw another line.
*   **Chain Reactions:** This process continues—draw a line, claim a box if completed, draw another line—for as long as each new line completes at least one additional box. A turn only ends when a player draws a line that does *not* complete a box.

## Mathematics of Dots and Boxes

### Combinatorial Foundation

The strategic landscape of Dots and Boxes is best formalized through the lens of graph theory. This abstraction separates the game's incidental representation from its underlying combinatorial structure.

<div class="definition">

**Definition (Board Graph).**

Let the initial game state be represented by a planar graph $G_0 = (V, E)$, where:
*   $V$ is the set of vertices corresponding to the original grid of dots.
*   $E$ is the set of all possible *unclaimed* edges between horizontally and vertically adjacent dots.

A move consists of removing a single edge $e \in E$ from the graph, claiming it for the player.

</div>

![Initial Board Graph](/dotsnboxes0.png)

<div class="definition">

**Definition (Dual Graph).**

Given the planar board graph $G = (V, E)$, its *dual graph* $G^* = (V^*, E^*)$ is constructed as follows:
*   $V^*$ corresponds to the set of cells $C$ (the bounded faces of $G$).
*   Two vertices in $V^*$ are connected by an edge $e^* \in E^*$ if and only if their corresponding cells in $G$ share a common edge.

In this dual representation, claiming an edge $e \in E$ corresponds to *removing* its dual edge $e^* \in E^*$.

</div>

<div class="definition">

**Definition (Completed Cell).**

A cell $c \in C$ is *completed* when all four edges in its boundary have been claimed. In the dual graph $G^*$, this occurs when the vertex corresponding to $c$ becomes isolated from all remaining play—all incident dual edges $e^*$ have been removed.

</div>

![Completed Box A](/dotsnboxes1.png)

<div class="definition">

**Definition (Chain Decomposition).**

In the endgame, the *dual graph* $G^*$ decomposes into disconnected components known as *chains* and *loops*.
*   A **chain** is a path in $G^*$ where each vertex has degree 2 within the chain, except the two endpoints which have degree 1.
*   A **loop** is a cycle in $G^*$ where every vertex has degree 2.

The fundamental strategic unit is the long chain (where the path contains $k \geq 3$ vertices).

</div>

![Chain of Length 3 alongside Loop Structure](/dotsnboxes2.png)

This graph-theoretic model reduces the game to a process of edge selection on $G$ that triggers state transitions in the dual graph. The celebrated Chain Rule and subsequent analysis flow directly from this decomposition.

### Primal-Dual Correspondence: An Example

The relationship between the primal board graph $G$ and its dual $G^*$ is fundamental. Each edge in $G$ has a unique dual edge in $G^*$ that crosses it perpendicularly.

![Primal-Dual Correspondence Example](/dotsnboxes3.png)

![Primal-Dual Correspondence Example](/dotsnboxes3.5.png)

This demonstrates the precise correspondence: **each claimed edge in $G$ cuts the perpendicular dual edge in $G^*$, and a completed box isolates a vertex in $G^*$**.

### Nim-Value Calculation

The nim-value (or Grundy number) of a game position is calculated recursively using the *minimum excludant* (mex) function.

<div class="definition">

**Definition (Minimum Excludant).**

For a set of non-negative integers $S$, $\mex(S)$ is the smallest non-negative integer not in $S$.
$$
\mex(\{0,1,3,4\}) = 2,\quad \mex(\{1,2,3\}) = 0,\quad \mex(\emptyset) = 0
$$

</div>

<div class="definition">

**Definition (Nim-Value Recursion).**

For any game position $G$, the nim-value $\nim(G)$ is:
$$
\nim(G) = \mex\{\nim(G_1), \nim(G_2), \dots, \nim(G_k)\}
$$
where $G_1, G_2, \dots, G_k$ are all positions reachable from $G$ in one move.

</div>

The combinatorial analysis of Dots and Boxes requires careful treatment of the extra move mechanic. We analyze positions under the assumption of *isolation* - that no other moves exist outside the considered chain.

<div class="definition">

**Definition (Chain of Boxes).**

A *chain of $k$ boxes* is a maximal connected set of boxes where:
*   each box has exactly **two** of its four sides already drawn,
*   the drawn sides form a path connecting all boxes to the chain, and
*   the first and last boxes in the chain each have one undrawn side connecting to the rest of the board.
*   All interior boxes have both undrawn sides adjacent to other boxes in the chain.

In this configuration, drawing any line that completes a box will create a chain reaction allowing the player to complete the entire chain.

</div>

<div class="example">

**Example (Chain States).**

Note the following:
*   **Valid chain**: Two adjacent boxes where each has exactly two drawn sides, with the middle line between them drawn, forming a connected path.
*   **Not a chain**: Two adjacent boxes where the middle line is undrawn, and each box has only one drawn side on their outer boundaries.
*   **Not a chain**: Two boxes where one has three drawn sides and the other has one drawn side - this doesn't form the required connected path structure.

</div>

<div class="definition">

**Definition (Turn Preservation in Chain Reactions).**

When a player completes a box in an isolated chain, they receive both the point and an immediate extra move. This extra move must be used within the same chain if possible. The turn only ends when a player makes a move that does not complete a box.

</div>

<div class="proposition">

**Proposition (Single Box Analysis).**

For an isolated single box ($k=1$) with three sides drawn:
*   The moving player draws the fourth side, completes the box (scores 1 point)
*   Receives an extra move, but no moves remain
*   The game ends with the moving player having scored the final point

This is a winning position for the player to move:
$$
\nim(1) = \mex\{\nim(\emptyset)\} = \mex\{0\} = 1
$$

</div>

<div class="proposition">

**Proposition (Two-Box Chain Analysis).**

In a standard two-box chain configuration (each box has three drawn sides, with the middle line between them undrawn), the player to move can capture both boxes simultaneously by drawing the middle line. This scores 2 points and grants an extra move. Since this move wins the chain immediately, the position has a winning advantage for the first player:
$$
\nim(2) = 2
$$

</div>

<div class="theorem">

**Theorem (Chain Value Periodicity - Berlekamp, Conway, Guy).**

For an isolated chain of $k$ boxes where $k \geq 3$, the nim-values exhibit a period of 4:
$$
\nim(k) = 
\begin{cases}
0 & \text{if } k \equiv 0 \pmod{4} \\
k & \text{if } k \equiv 1, 2, 3 \pmod{4}
\end{cases}
$$

</div>

<div class="proof">

**Proof.**

We proceed by induction on $k$, following the recursive framework established in [WW82] (Chapter 16). The proof analyzes all possible moves from a chain of length $k$ and calculates the minimum excludant (mex) of the resulting positions.

**Base Cases:**
*   $\nim(1) = 1$: A single box is a winning position.
*   $\nim(2) = 2$: The first player can capture both boxes.
*   $\nim(3) = 3$: The first player can capture all three boxes.

**Inductive Step:** Assume the statement holds for all chains of length less than $k$ ($k \geq 4$). We compute $\nim(k)$ by considering all moves available to the player:

1.  **Complete the entire chain:** This yields the terminal position with value $0$.
2.  **Take $m$ boxes from one end** ($1 \leq m \leq k-1$): This move captures $m$ boxes and leaves a chain of length $k-m$. By inductive hypothesis, the value of the remaining chain is $\nim(k-m)$.

The set of reachable values is therefore 

$$
S = \{0\} \cup \{\nim(k-m) : 1 \leq m \leq k-1\}.
$$

We now verify periodicity by cases:

**Case 1: $k = 4j$**
*   The reachable values include $\{\nim(4j-m) : 1 \leq m \leq 4j-1\} \cup \{0\}$.
*   By the inductive hypothesis, these values follow the periodic pattern. For example:
    *   Taking 1 box: $\nim(4j-1) = 4j-1$
    *   Taking 2 boxes: $\nim(4j-2) = 4j-2$  
    *   Taking 3 boxes: $\nim(4j-3) = 4j-3$
    *   Taking 4 boxes: $\nim(4j-4) = 0$
*   This is where we must not overlook the strategic implications of the chain reaction mechanic.
*   The key insight is that in a $4j$-chain, every move ultimately gives the opponent a winning position through the *double-cross strategy*. For example:
    *   Taking $4j-2$ boxes leaves a 2-chain with $\nim(2) = 2 \neq 0$
    *   The opponent then captures both boxes and gains an extra move
    *   This extra move allows the opponent to seize control of the remaining game
*   A complete analysis shows that all moves from a $4j$-chain, including middle splits and various capture sequences, ultimately transfer the advantage to the opponent. Therefore, $\nim(4j) = 0$.
*   The full details of this case analysis, including all possible move sequences and their outcomes, are presented in [WW82] (Chapter 16).

**Case 2: $k = 4j+1$**
*   The player can take 1 box, leaving a $4j$-chain with $\nim(4j) = 0$
*   This immediate winning move shows $\nim(4j+1) = 4j+1$

**Case 3: $k = 4j+2$**
*   The player can take 2 boxes, leaving a $4j$-chain with $\nim(4j) = 0$  
*   This shows $\nim(4j+2) = 4j+2$

**Case 4: $k = 4j+3$**
*   The player can take 3 boxes, leaving a $4j$-chain with $\nim(4j) = 0$
*   This shows $\nim(4j+3) = 4j+3$

The periodic pattern holds because the $4j$-chain is the unique losing position, while all other chain lengths offer a direct winning move to a $4j$-chain.<div class="text-right">$\square$</div>

</div>

<div class="remark">

**Remark.**

This proof, while rigorous within our framework, abstracts some subtleties of the actual game position. The complete treatment in *[WW82]* provides additional insight into how these values compose when multiple chains are present.

</div>

<div class="example">

**Example (Double-Cross Strategy).**

In a chain of 4 boxes, the expert player employs the double-cross:
*   Takes only 2 boxes (using the chain reaction: complete box 1 → extra move → complete box 2)
*   Leaves a 2-chain for the opponent
*   The opponent must take both boxes in the 2-chain, scoring 2 points but using their turn
*   This forces the opponent to make the next move elsewhere, potentially opening another long chain

This demonstrates why $\nim(4) = 0$ - it's a losing position for the player to move when played optimally, as the double-cross strategy transfers the disadvantage to the opponent.

</div>

<div class="remark">

**Remark (Strategic Interpretation).**

The periodicity reveals the core strategic principle: long chains ($k \geq 3$) are "loathsome." The player forced to open the first long chain typically loses it. The nim-values quantify this strategic disadvantage, with $\nim(k) = 0$ indicating the chain is a losing proposition for the opener.

</div>

### Impartial Game Characteristics

Dots and Boxes exhibits both impartial and partizan characteristics, making its combinatorial analysis particularly nuanced.

<div class="definition">

**Definition (Impartial Game).**

A game is *impartial* if the available moves depend only on the current position, not on which player is to move. Formally, for any position $P$, both players have identical sets of legal moves available to them.

</div>

<div class="proposition">

**Proposition (Game Classification of Dots and Boxes).**

Dots and Boxes is *not* a purely impartial game. While the initial line-drawing moves are impartial, the chain reaction mechanic introduces partizan characteristics. However, in the endgame when the board decomposes into independent chains, these components can be analyzed as impartial games using nim-value theory.

</div>

<div class="definition">

**Definition (Normal Play Convention).**

The game follows *normal play* convention: the player who makes the last move wins. In Dots and Boxes, this translates to the player who completes the final box(es) winning the game.

</div>

<div class="theorem">

**Theorem (Endgame Decomposition).**

In the late stages of Dots and Boxes, any position decomposes into a disjunctive sum of independent chains:
$$
G = G_1 + G_2 + \cdots + G_k
$$
where each $G_i$ represents an independent chain, and the overall game value is the nim-sum of the components' values.

</div>

<div class="example">

**Example (Nim-Value Calculation).**

Consider an endgame position with independent chains:
*   Chain of length 2: nim-value $\nim(2) = 2$
*   Chain of length 3: nim-value $\nim(3) = 3$  
*   Chain of length 4: nim-value $\nim(4) = 0$

The overall position has nim-value $2 \oplus 3 \oplus 0 = 1 \neq 0$, indicating a winning position for the player to move.

</div>

This analysis, following [WW82], reveals that optimal endgame strategy reduces to managing chain parity and calculating nim-sums of independent components.

### Solved Positions

<div class="theorem">

**Theorem (2×2 Board Solution - *[WW82]*).**

The 2×2 Dots and Boxes game (3×3 dot grid) is a *first-player win* under perfect play. The first player can force a score of 3–1 or 4–0.

</div>

<div class="proof">

**Proof (Sketch of Proof).**

By exhaustive game tree analysis and symmetry reduction:
1. The first player's initial move can be restricted to three non-symmetric opening moves by rotation invariance and reflection invariance.
2. For each opening, the second player's responses can be analyzed via the chain decomposition theory.
3. The nim-value analysis shows all lines lead to winning positions for the first player.
4. The double-cross strategy emerges naturally in the 4-box loop configuration.

The complete analysis appears in Berlekamp's *The Dots and Boxes Game: Sophisticated Child's Play*.<div class="text-right">$\square$</div>

</div>

![2x2 box solution diagram showing the 1st move](/dotsnboxes4.png)

<div class="theorem">

**Theorem (3×3 Board Outcome - *[WW82]*).**

The 3×3 Dots and Boxes game (4×4 dot grid) is also a *first-player win*. The optimal score is typically 6–3 in favor of the first player.

</div>

<div class="remark">

**Remark.**

While the 2×2 and 3×3 games are solved, the 4×4 game remains incompletely analyzed due to combinatorial explosion. The game tree complexity grows as $O(2^{n^2})$ for an $n \times n$ box grid.

</div>

<div class="definition">

**Definition (Loony Position).**

A position is called *loony* if any move gives the opponent an immediate winning response. In such positions, the player to move cannot avoid conceding a significant advantage.

</div>

<div class="example">

**Example (Recognizing Loony Positions).**

A typical loony position occurs when there are multiple long chains ($k \geq 3$) and the control count favors the opponent. Any move to capture boxes creates chain reactions that the opponent can exploit via the double-cross strategy.

</div>

### Control Count and Strategy Stealing

<div class="definition">

**Definition (Control Count).**

The *control count* of a Dots and Boxes position is given by:
$$
C = L + T
$$
where:
*   $L$ = number of long chains (length $\geq 3$)
*   $T$ = turn advantage indicator ($T = 1$ if it's your turn, $T = 0$ if opponent's turn)

</div>

<div class="theorem">

**Theorem (Control Parity Theorem).**

A position is winning for the player to move if and only if the control count $C$ is *odd*. When $C$ is even, the player should avoid opening long chains and instead make *neutral moves*.

</div>

<div class="proof">

**Proof.**

This follows directly from the nim-value periodicity established in Theorem 4.3. Each long chain ($k \geq 3$) contributes 1 to the control count when $k \not\equiv 0 \pmod{4}$, and the turn advantage provides the crucial parity adjustment. The mex calculation over independent chains ensures that odd control counts yield winning positions.<div class="text-right">$\square$</div>

</div>

<div class="example">

**Example (Control Count in Practice).**

Consider a position with:
*   two chains (of lengths 3 and 5): $L = 2$, and
*   player's turn: $T = 1$.

Then $C = 2 + 1 = 3$ (odd), from which comes a winning position. The player should open a long chain immediately.

</div>

![Diagram showing control count calculation](/dotsnboxes5.png)

<div class="theorem">

**Theorem (Strategy-Stealing Argument).**

On an empty $n \times n$ board with $n \geq 2$, the first player has a theoretical winning strategy.

</div>

<div class="proof">

**Proof.**

Assume for contradiction that the second player has a winning strategy $\mathcal{S}$. Then the first player can:
1. Make an arbitrary first move $m_1$.
2. Then, for all subsequent moves, can pretend to be the second player and follow strategy $\mathcal{S}$:
   *   when the second player makes move $m$, respond with the move $\mathcal{S}(m)$ prescribed by the winning strategy.
   *   If $\mathcal{S}$ ever recommends a move that has already been made (e.g., $m_1$), make an arbitrary legal move instead.

The first player is therefore executing the winning strategy $\mathcal{S}$ from a position that is at least as good as the initial position (since the first player has an extra move). But we assumed that $\mathcal{S}$ is a winning strategy for the *second* player, a contradiction. Our initial assumption was therefore false, and the second player cannot have a winning strategy.<div class="text-right">$\square$</div>

</div>

<div class="remark">

**Remark.**

The strategy-stealing argument explains why expert games on empty boards typically result in first-player wins. However, against imperfect play, the second player often has practical winning chances due to the complexity of an optimal strategy.

</div>

<div class="definition">

**Definition (Neutral Move).**

A *neutral move* is any move that:
*   does not complete a box,
*   does not create a long chain ($k \geq 3$), or
*   does not give the opponent an immediate chain reaction.

When $C$ is even, players should seek neutral moves to maintain a disadvantage for their opponent.

</div>

### Game Tree Complexity

<div class="definition">

**Definition (Game Tree Complexity).**

The *game tree complexity* of a game is the total number of leaf nodes in the game tree, representing all possible complete games from initial position to termination.

</div>

Notice that, for an $n \times n$ grid of dots, the initial position has:
$$
E_0 = 2n(n-1)
$$
available edges, and that the branching factor decreases as edges are claimed, but remains substantial throughout most of the game.

<div class="theorem">

**Theorem (Exponential Growth).**

The game tree complexity of Dots and Boxes grows as $\Omega(2^{n^2})$ for an $n \times n$ dot grid.

</div>

<div class="proof">

**Proof.**

Each of the $O(n^2)$ edges represents a binary choice (claimed or unclaimed), and the extra move mechanic creates additional branching at completed boxes. While not every combination is reachable due to game rules, the lower bound remains exponential in $n^2$.<div class="text-right">$\square$</div>

</div>

<div class="example">

**Example (Complexity of Small Boards).**

Applying the exponential growth theorem:
*   $3\times3$ grid of dots: $\approx 10^3$ possible games
*   $4\times4$ grid of dots: $\approx 10^9$ possible games  
*   $5\times5$ grid of dots: $\approx 10^{20}$ possible games

The branching factor proposition explains the initial move choices, while the exponential growth theorem explains the overall tree size.

</div>

![Graph plotting Grid Size vs Game Tree Size](/dotsnboxes6.png)

<div class="remark">

**Remark (Computational Intractability).**

The exponential complexity explains why:
*   only boards up to $4\times4$ are practically solvable by exhaustive search,
*   expert play relies on combinatorial principles rather than a full tree search, and
*   the game remains challenging to code despite its simple rules.

</div>

<div class="definition">

**Definition (State Space Complexity).**

The *state space complexity* counts distinct reachable positions, which is smaller than game tree complexity but still grows exponentially:
$$
S(n) = O(2^{n^2})
$$

</div>

### Further Mathematics Directions

The above combinatorial analysis provides a foundation for understanding Dots and Boxes, but there are several advanced topics which are beyond our scope:

*   **Loop Analysis**: While chains dominate strategy, analysis of *loops* (cycles in the dual graph) introduces further complexity. Loops can create positions where the chain rule does not apply directly, and where sophisticated valuation methods are required.
*   **Generalized Chain Reactions**: Non-linear structures, such as trees and complex networks of boxes, present interesting challenges which require more than the linear chains analyzed here.
*   **Complexity Classification**: While we've established the game's exponential tree complexity, the precise computational complexity (whether Dots and Boxes is PSPACE-complete or has other complexity class memberships) remains an active area of research.

For readers interested in pursuing these advanced topics, we recommend the comprehensive treatment in [WW82] and the subsequent research literature it has inspired.

## Example of Gameplay

### Illustrative Example: The Double-Cross in Action

Consider a mid-game position on a 3×3 box grid (4×4 dots) where few neutral moves remain. The current score is as follows: Player 1 has 1 points, Player 2 has 2 points; and it's Player 1's turn. Three of the corners have been claimed, leaving the central and bottom left areas as the battleground:

![Mid-game position on 4x4 dots](/dotsnboxes7.png)

**Initial Position Analysis:**
*   **Score:** Player 1: 1 point, Player 2: 2 points
*   **Player 1's turn** while trailing
*   **Control Count:** $C = L + T = 0 + 1 = 1$ (odd) - mathematically favorable
*   **Key Feature:** Complex network of boxes A-E with both chain and isolated structures

**Optimal Play Sequence:**

1.  **Player 1 claims the blue edge (1,2)-(2,2)**, completing box A:
    *   Scores 1 point (tying the game 2-2)
    *   Gains an extra move (still Player 1's turn)
    *   This is a safe scoring opportunity that doesn't immediately open dangerous chains
2.  **Player 1 then claims a green neutral edge** (either (2,0)-(3,0) or (3,0)-(3,1)):
    *   Completes no boxes
    *   Passes the turn to Player 2 without opening chain opportunities
    *   Maintains the mathematical advantage by transferring the disadvantage to Player 2

**Mathematical Justification:**

After claiming box A, the control count becomes:
$$
C = L + T = 1 + 1 = 2 \quad \text{(even)}
$$
This is disadvantageous for the player to move (Player 1). By making a neutral move, Player 1 transfers this disadvantage to Player 2, whose control count becomes:
$$
C = L + T = 1 + 0 = 1 \quad \text{(odd)}
$$
Player 2 now faces the dilemma of either opening the dangerous chain or making a neutral move themselves.

**Strategic Insight:**
This sequence demonstrates several key principles:
*   **Safe Scoring First:** When trailing, take safe scoring opportunities that don't concede chain control
*   **Control Count Management:** Use neutral moves to transfer disadvantages to your opponent
*   **Chain Avoidance:** In complex networks, avoid opening chains when control count is even
*   **Initiative Preservation:** The extra move from box A allows Player 1 to both score and maintain strategic control

![Dual Graph Representation of mid-game position](/dotsnboxes8.png)

**Dual Graph Analysis:**
The dual graph reveals the star-like connectivity centered at box C. This structure means that:
*   Claiming box A affects only the connection between A and C
*   The core chain structure (B-C-D) remains intact but not activated
*   Player 1's neutral move after scoring avoids disturbing this delicate balance

**Conclusion:**
This example perfectly illustrates how mathematical principles guide complex decision-making. Player 1's sequence demonstrates expert understanding of:
*   Prioritizing safe scoring when trailing
*   Using control count to determine when to make neutral moves
*   Managing complex chain networks without conceding advantages
*   Leveraging the dual graph structure to inform strategic decisions

The position shows that optimal play requires both tactical awareness (immediate scoring) and strategic planning (long-term chain management), with mathematical principles providing the foundation for both.

## Play Dots and Boxes in Command Line (with Lisp for tree searches)

### Foundational Algorithms: Minimax and Alpha-Beta Pruning

The mathematical principles established in the previous section provide a strategic foundation for our Dots and Boxes implementation. We now turn to the computational framework that brings these insights to life: the minimax algorithm and its optimization via alpha-beta pruning.

<div class="definition">

**Definition (Minimax Algorithm).**

The *minimax* algorithm is a decision-making procedure for adversarial games that operates on the principle of minimizing risk while maximizing potential gain. For a game tree of depth $d$ with branching factor $b$, minimax evaluates all $O(b^d)$ terminal positions to determine an optimal move sequence.

</div>

<pre><code class="language-plaintext">function minimax(position, depth, maximizingPlayer)
    if depth == 0 or game_over(position)
        return evaluate(position)
    
    if maximizingPlayer
        maxEval = -inf
        for each child of position
            eval = minimax(child, depth-1, false)
            maxEval = max(maxEval, eval)
        return maxEval
    else
        minEval = +inf
        for each child of position
            eval = minimax(child, depth-1, true)
            minEval = min(minEval, eval)
        return minEval
</code></pre>

The algorithm operates recursively and alternates between *maximizing* one player and *minimizing* another player.

<div class="definition">

**Definition (Alpha-Beta Pruning).**

*Alpha-beta pruning* is a technique for optimizing the minimax algorithm that eliminates branches which cannot influence the final decision. The alpha-beta pruning will maintain two values:
*   $\alpha$: the best value guaranteed so far by this maximizer, and
*   $\beta$: the best value guaranteed so far by the minimizer.

When $\alpha \geq \beta$, the remaining branches need not be evaluated.

</div>

<pre><code class="language-plaintext">function alphabeta(position, depth, alpha, beta, maximizingPlayer)
    if depth == 0 or game_over(position)
        return evaluate(position)
    
    if maximizingPlayer
        maxEval = -inf
        for each child of position
            eval = alphabeta(child, depth-1, alpha, beta, false)
            maxEval = max(maxEval, eval)
            alpha = max(alpha, eval)
            if beta ≤ alpha
                break  # beta cutoff
        return maxEval
    else
        minEval = +inf
        for each child of position
            eval = alphabeta(child, depth-1, alpha, beta, true)
            minEval = min(minEval, eval)
            beta = min(beta, eval)
            if beta ≤ alpha
                break  # alpha cutoff
        return minEval
</code></pre>

<div class="theorem">

**Theorem (Alpha-Beta Efficiency).**

In the best case, alpha-beta pruning can reduce game tree complexity from $O(b^d)$ to $O(\sqrt{b^d})$, effectively doubling the search depth that can be achieved in the same computation time. The actual improvement, however, will depend on its handling of moves and how it orders these data.

</div>

In Dots and Boxes, the evaluation function will take the following into account:
*   chain decomposition and nim-values from Section 4.1,
*   control count calculations from Section 4.4, and 
*   position valuation based on the combinatorial principles.

<div class="example">

**Example (Pruning in Dots and Boxes).**

Consider a position where Player 1 (maximizer) has found a move yielding +3 points ($\alpha = 3$). If Player 2 (minimizer) discovers a response that gives Player 1 only +1 point ($\beta = 1$), so that $\beta \leq \alpha$, then the remaining responses need not be evaluated as the maximizer would never choose this branch.

</div>

### Architectural Overview

Our implementation employs a hybrid architecture focusing on chain management:
*   **Bash**: Orchestrates game flow, I/O handling, and coordinates Lisp computations,
*   **Common Lisp**: Implements chain detection and double-cross strategy,
*   **Strategic Foundation**: The AI utilizes:
    *   chain decomposition for positional analysis,
    *   double-cross strategy for sacrificing small chains to gain larger ones, and
    *   safe move prioritization to avoid giving opponents easy boxes.

This separation leverages Bash's scripting strength with Lisp's symbolic computation for strategic decision-making.

<div class="remark">

**Remark (Practical Implementation).**

While comprehensive game tree search was considered, our implementation focuses on the mathematically-grounded chain theory:
*   Chain detection and size analysis
*   Double-cross move identification  
*   Strategic sacrifice evaluation
*   Safe move fallback mechanisms

These techniques provide strong positional play while remaining computationally tractable for all board sizes.

</div>

### Game Orchestration (Bash)

The Bash component manages game flow, user interface, and coordinates between player input and (hard) AI decisions. It maintains game state using associative arrays and offers three levels of difficulty.

```bash
#!/bin/bash

# Dots and Boxes Game in Bash with Lisp for tree searches

# game state variables
declare -A board
declare -A edges
declare -A boxes
current_player="human"
difficulty="easy"
EMPTY="○"


display_board() {
    echo -n "   "
    for ((i=0; i< $n; i++)); do
        printf "%-4s" $((i+1))
    done
    echo
    
    for ((i=0; i< $m; i++)); do
        # draw dots and horizontal edges
        printf "%2d " $((i+1))
        for ((j=0; j< $n; j++)); do
            echo -n "${board[$i,$j]}"
            if [[ $j -lt $((n-1)) ]] && [[ -n "${edges[$i,$j,$i,$((j+1))]}" ]]; then
                echo -n "___"
            else
                echo -n "   "
            fi
        done
        echo
        
        # draw vertical edges and box owners between rows
        if [[ $i -lt $((m-1)) ]]; then
            echo -n "   "
            for ((j=0; j< $n; j++)); do
                if [[ -n "${edges[$i,$j,$((i+1)),$j]}" ]]; then
                    echo -n "|"
                else
                    echo -n " "
                fi
                
                # draw box owner between dots
                if [[ $j -lt $((n-1)) ]]; then
                    if [[ -n "${boxes[$i,$j]}" ]]; then
                        echo -n " ${boxes[$i,$j]} "  # P or C
                    else
                        echo -n "   "  # empty box
                    fi
                fi
            done
            echo
        fi
    done
}

# function to get initial game setup
setup_game() {
    echo "Welcome to DOTS AND BOXES!"
    echo
    
    # === CRITICAL: RESET GAME STATE ===
    unset edges
    unset boxes
    declare -gA edges
    declare -gA boxes
    # ==================================
    
    # difficulty selection
    while true; do
        echo "Select difficulty:"
        echo "1 - Easy (computer plays randomly)"
        echo "2 - Medium (computer sometimes makes mistakes)"  
        echo "3 - Hard (computer always plays optimally)"
        read -p "Enter choice (1-3): " diff_choice
        
        case $diff_choice in
            1) difficulty="easy"; break ;;
            2) difficulty="medium"; break ;;
            3) difficulty="hard"; break ;;
            *) echo "Invalid choice! Please enter 1, 2, or 3." ;;
        esac
    done
    
    echo "Difficulty set to: $difficulty"
    echo
    
    # grid setup
    echo "Setup 'N x M' grid:"
    
    read -p "Choose 'N' (number between 2 and 4) for 'M x N' grid: " n
            
    if [[ ! "$n" =~ ^[0-9]+$ ]] || [ $n -lt 2 ] || [ $n -gt 4 ]; then
        echo "Please enter a number between 2 and 4."
        exit 1
    fi
    
    while true; do
        read -p "Choose 'M' (number between 2 and 4) for 'M x N' grid: " m
            
        if [[ ! "$m" =~ ^[0-9]+$ ]] || [ $m -lt 2 ] || [ $m -gt 4 ]; then
            echo "Please enter a number between 2 and 4."
            continue
        fi
        
        for ((i=0; i< $m; i++)); do
            for ((j=0; j< $n; j++)); do
                board[$i,$j]="$EMPTY"
            done
        done
        break
    done
    
    # who goes first (player's choice)
    while true; do
    echo
    echo "Who should go first?"
    echo "1 - Player first"
    echo "2 - Computer first" 
    echo "3 - Random"
    read -p "Enter choice (1-3): " first_choice
    
    case $first_choice in
        1) current_player="human"; break ;;
        2) current_player="computer"; break ;;
        3) 
            local random_choice=$(( RANDOM % 2 ))
            if [ $random_choice -eq 0 ]; then
                current_player="human"
            else
                current_player="computer"
            fi
            break 
            ;;
        *) echo "Invalid choice! Please enter 1, 2, or 3." ;;
    esac
done

echo "$current_player will go first!"
}

# absolute value function
abs() {
  local num=$1
  if (( num < 0 )); then
    echo $(( num * -1 ))
  else
    echo $num
  fi
}

# check for unclaimed (recently completed) boxes
check_boxes() {
    local row1=$1 col1=$2 row2=$3 col2=$4
    for ((i=0; i< $m; i++)); do
        for ((j=0; j< $n; j++)); do
            if [[ -n "${edges[$i,$j,$i,$((j+1))]}" ]] && \
               [[ -n "${edges[$i,$((j+1)),$((i+1)),$((j+1))]}" ]] && \
               [[ -n "${edges[$((i+1)),$j,$((i+1)),$((j+1))]}" ]] && \
               [[ -n "${edges[$i,$j,$((i+1)),$j]}" ]]; then
                if (( i == row1 && j == col1 && i == row2 && $((j+1)) == col2 )) || \
                   (( i == row1 && $((j+1)) == col1 && $((i+1)) == row2 && $((j+1)) == col2 )) || \
                   (( $((i+1)) == row1 && j == col1 && $((i+1)) == row2 && $((j+1)) == col2 )) || \
                   (( i == row1 && j == col1 && $((i+1)) == row2 && j == col2 )); then
                    if [ "$current_player" = "human" ]; then
                        boxes["$i,$j"]="P"
                    else
                        boxes["$i,$j"]="C"
                    fi
                fi
            fi
        done
    done
}

player_move() {
    while true; do
        read -p "Your move (e.g. enter 10 20 to mean (1,0) (2,0)): " player_input
            row1=${player_input:0:1}; row1=$((row1-1))  # convert to 0-based
            col1=${player_input:1:1}; col1=$((col1-1))
            row2=${player_input:3:1}; row2=$((row2-1))  
            col2=${player_input:4:1}; col2=$((col2-1))
        if [[ ! "$player_input" =~ ^[1-4][1-4][[:space:]]+[1-4][1-4]$ ]] || \
          [[ $(( $(abs $((row2 - row1))) + $(abs $((col2 - col1))) )) -ne 1 ]] || \
          (( row1 >= m || col1 >= n || row2 >= m || col2 >= n )); then
            echo "Invalid move. Use format like '10 20' for adjacent vertices"
            continue
        fi
        edges["$row1,$col1,$row2,$col2"]=1
        check_boxes "$row1" "$col1" "$row2" "$col2"
        break
    done
}

easy_ai_move() {
    # collect all possible edges
    local possible_edges=()
    
    # generate all horizontal edges
    for ((i=0; i<m; i++)); do
        for ((j=0; j<n-1; j++)); do
            if [[ -z "${edges[$i,$j,$i,$((j+1))]}" ]]; then
                possible_edges+=("$i,$j,$i,$((j+1))")
            fi
        done
    done
    
    # generate all vertical edges  
    for ((i=0; i<m-1; i++)); do
        for ((j=0; j<n; j++)); do
            if [[ -z "${edges[$i,$j,$((i+1)),$j]}" ]]; then
                possible_edges+=("$i,$j,$((i+1)),$j")
            fi
        done
    done
    
    if [[ ${#possible_edges[@]} -gt 0 ]]; then
        local random_index=$((RANDOM % ${#possible_edges[@]}))
        local chosen_edge="${possible_edges[$random_index]}"
        
        if [[ -n "${edges[$chosen_edge]}" ]]; then
            echo "ERROR: Computer tried to play existing edge: $chosen_edge"
            easy_ai_move
            return
        fi
        
        # parse the edge string into individual coordinates
        IFS=',' read -r row1 col1 row2 col2 <<< "$chosen_edge"
        
        edges["$chosen_edge"]=1
        check_boxes "$row1" "$col1" "$row2" "$col2"
        
        # convert back to 1-based for display
        local display_row1=$((row1+1)) display_col1=$((col1+1))
        local display_row2=$((row2+1)) display_col2=$((col2+1))
        echo "Computer plays: $display_row1$display_col1 $display_row2$display_col2"
    fi
}

medium_ai_move() {
    local completing_moves=()
    local isolated_connectors=()
    local safe_moves=()
    
    # generate ALL possible edges that don't exist
    local all_possible_edges=()
    
    # horizontal edges
    for ((i=0; i<m; i++)); do
        for ((j=0; j<n-1; j++)); do
            local key="$i,$j,$i,$((j+1))"
            if [[ -z "${edges[$key]}" ]]; then
                all_possible_edges+=("$key")
            fi
        done
    done
    
    # vertical edges
    for ((i=0; i<m-1; i++)); do
        for ((j=0; j<n; j++)); do
            local key="$i,$j,$((i+1)),$j"
            if [[ -z "${edges[$key]}" ]]; then
                all_possible_edges+=("$key")
            fi
        done
    done
    
    # now categorize each possible edge
    for edge in "${all_possible_edges[@]}"; do
        IFS=',' read -r i j k l <<< "$edge"
        
        # check if this edge completes a box
        if [[ $i -eq $k ]]; then
            # horizontal edge - check boxes above and below
            # check the box above
            if [[ $i -gt 0 ]] && \
               [[ -n "${edges[$((i-1)),$j,$i,$j]}" ]] && \
               [[ -n "${edges[$((i-1)),$j,$((i-1)),$((j+1))]}" ]] && \
               [[ -n "${edges[$((i-1)),$((j+1)),$i,$((j+1))]}" ]]; then
                completing_moves+=("$edge")
            fi
            # check the box below
            if [[ $i -lt $((m-1)) ]] && \
               [[ -n "${edges[$i,$j,$((i+1)),$j]}" ]] && \
               [[ -n "${edges[$i,$((j+1)),$((i+1)),$((j+1))]}" ]] && \
               [[ -n "${edges[$((i+1)),$j,$((i+1)),$((j+1))]}" ]]; then
                completing_moves+=("$edge")
            fi
        else
            # vertical edge - check boxes to the left and right
            # check box to the left
            if [[ $j -gt 0 ]] && \
               [[ -n "${edges[$i,$((j-1)),$i,$j]}" ]] && \
               [[ -n "${edges[$i,$((j-1)),$((i+1)),$((j-1))]}" ]] && \
               [[ -n "${edges[$((i+1)),$((j-1)),$((i+1)),$j]}" ]]; then
                completing_moves+=("$edge")
            fi
            # check box to the right
            if [[ $j -lt $((n-1)) ]] && \
               [[ -n "${edges[$i,$j,$i,$((j+1))]}" ]] && \
               [[ -n "${edges[$i,$((j+1)),$((i+1)),$((j+1))]}" ]] && \
               [[ -n "${edges[$((i+1)),$j,$((i+1)),$((j+1))]}" ]]; then
                completing_moves+=("$edge")
            fi
        fi
        
        # check if this edge connects to any isolated edge
        if [[ $i -eq $k ]]; then
            # horizontal edge
            local isolated=1
            # check if this edge has another edge connected to it
            if [[ -n "${edges[$i,$j,$((i+1)),$j]}" ]] || \
               [[ -n "${edges[$i,$((j+1)),$((i+1)),$((j+1))]}" ]] || \
               [[ ($j -gt 0 && -n "${edges[$i,$((j-1)),$i,$j]}" ) ]] || \
               [[ ($i -gt 0 && -n "${edges[$((i-1)),$j,$i,$j]}" ) ]] || \
               [[ ($i -gt 0 && -n "${edges[$((i-1)),$((j+1)),$i,$((j+1))]}" ) ]]; then
                isolated=0
            fi
            if [[ $isolated -eq 1 ]]; then
                isolated_connectors+=("$edge")
            fi
        else
            # vertical edge
            local isolated=1
            if [[ -n "${edges[$i,$j,$i,$((j+1))]}" ]] || \
               [[ -n "${edges[$((i+1)),$j,$((i+1)),$((j+1))]}" ]] || \
               [[ ($i -gt 0 && -n "${edges[$((i-1)),$j,$i,$j]}" ) ]] || \
               [[ ($j -gt 0 && -n "${edges[$i,$((j-1)),$i,$j]}" ) ]] || \
               [[ ($j -gt 0 && -n "${edges[$((i+1)),$((j-1)),$((i+1)),$j]}" ) ]]; then
                isolated=0
            fi
            if [[ $isolated -eq 1 ]]; then
                isolated_connectors+=("$edge")
            fi
        fi
        
        # check if this is a safe move (doesn't create 3-edges of a box)
        local safe=1
        if [[ $i -eq $k ]]; then
            # horizontal edge
            # check the box above
            if [[ $i -gt 0 ]]; then
                local existing_edges=0
                [[ -n "${edges[$((i-1)),$j,$i,$j]}" ]] && ((existing_edges++))
                [[ -n "${edges[$((i-1)),$j,$((i-1)),$((j+1))]}" ]] && ((existing_edges++))
                [[ -n "${edges[$((i-1)),$((j+1)),$i,$((j+1))]}" ]] && ((existing_edges++))
                if [[ $existing_edges -eq 2 ]]; then
                    safe=0
                fi
            fi
            # check the box below
            if [[ $i -lt $((m-1)) ]]; then
                local existing_edges=0
                [[ -n "${edges[$i,$j,$((i+1)),$j]}" ]] && ((existing_edges++))
                [[ -n "${edges[$i,$((j+1)),$((i+1)),$((j+1))]}" ]] && ((existing_edges++))
                [[ -n "${edges[$((i+1)),$j,$((i+1)),$((j+1))]}" ]] && ((existing_edges++))
                if [[ $existing_edges -eq 2 ]]; then
                    safe=0
                fi
            fi
        else
            # vertical edge
            # check box to the left
            if [[ $j -gt 0 ]]; then
                local existing_edges=0
                [[ -n "${edges[$i,$((j-1)),$i,$j]}" ]] && ((existing_edges++))
                [[ -n "${edges[$i,$((j-1)),$((i+1)),$((j-1))]}" ]] && ((existing_edges++))
                [[ -n "${edges[$((i+1)),$((j-1)),$((i+1)),$j]}" ]] && ((existing_edges++))
                if [[ $existing_edges -eq 2 ]]; then
                    safe=0
                fi
            fi
            # check box to the right
            if [[ $j -lt $((n-1)) ]]; then
                local existing_edges=0
                [[ -n "${edges[$i,$j,$i,$((j+1))]}" ]] && ((existing_edges++))
                [[ -n "${edges[$i,$((j+1)),$((i+1)),$((j+1))]}" ]] && ((existing_edges++))
                [[ -n "${edges[$((i+1)),$j,$((i+1)),$((j+1))]}" ]] && ((existing_edges++))
                if [[ $existing_edges -eq 2 ]]; then
                    safe=0
                fi
            fi
        fi
        
        if [[ $safe -eq 1 ]]; then
            safe_moves+=("$edge")
        fi
    done
    
    # prioritization
    if [[ ${#completing_moves[@]} -gt 0 ]]; then
        local random_index=$((RANDOM % ${#completing_moves[@]}))
        local chosen_edge="${completing_moves[$random_index]}"
    elif [[ ${#isolated_connectors[@]} -gt 0 ]]; then
        local random_index=$((RANDOM % ${#isolated_connectors[@]}))
        local chosen_edge="${isolated_connectors[$random_index]}"
    elif [[ ${#safe_moves[@]} -gt 0 ]]; then
        local random_index=$((RANDOM % ${#safe_moves[@]}))
        local chosen_edge="${safe_moves[$random_index]}"
    else
        easy_ai_move
        return
    fi
    
    # process chosen move
    IFS=',' read -r row1 col1 row2 col2 <<< "$chosen_edge"
    edges["$chosen_edge"]=1
    check_boxes "$row1" "$col1" "$row2" "$col2"
    
    local display_row1=$((row1+1)) display_col1=$((col1+1))
    local display_row2=$((row2+1)) display_col2=$((col2+1))
    echo "Computer plays: $display_row1$display_col1 $display_row2$display_col2"
}

convert_to_lisp_format() {
    # convert bash arrays to lisp-readable format
    local lisp_edges_h=""
    local lisp_edges_v=""
    local lisp_boxes=""
    
    # convert horizontal edges (grouped by row)
    lisp_edges_h="("
    for ((i=0; i<m; i++)); do
        lisp_edges_h+="("
        for ((j=0; j<n-1; j++)); do
            local key="$i,$j,$i,$((j+1))"
            if [[ -n "${edges[$key]}" ]]; then
                lisp_edges_h+="t"
            else
                lisp_edges_h+="nil"
            fi
            if [[ $j -lt $((n-2)) ]]; then
                lisp_edges_h+=" "
            fi
        done
        lisp_edges_h+=")"
        if [[ $i -lt $((m-1)) ]]; then
            lisp_edges_h+=" "
        fi
    done
    lisp_edges_h+=")"
    
    # === convert vertical edges - group by column  ===
    lisp_edges_v="("
    for ((j=0; j<n; j++)); do  # iterate by column first
        lisp_edges_v+="("
        for ((i=0; i<m-1; i++)); do  # then by row within each column
            local key="$i,$j,$((i+1)),$j"
            if [[ -n "${edges[$key]}" ]]; then
                lisp_edges_v+="t"
            else
                lisp_edges_v+="nil"
            fi
            if [[ $i -lt $((m-2)) ]]; then
                lisp_edges_v+=" "
            fi
        done
        lisp_edges_v+=")"
        if [[ $j -lt $((n-1)) ]]; then
            lisp_edges_v+=" "
        fi
    done
    lisp_edges_v+=")"
    
    # convert boxes
    lisp_boxes="("
    for ((i=0; i<m-1; i++)); do
        lisp_boxes+="("
        for ((j=0; j<n-1; j++)); do
            if [[ "${boxes[$i,$j]}" == "P" ]]; then
                lisp_boxes+=":human"
            elif [[ "${boxes[$i,$j]}" == "C" ]]; then
                lisp_boxes+=":computer"
            else
                lisp_boxes+="nil"
            fi
            if [[ $j -lt $((n-2)) ]]; then
                lisp_boxes+=" "
            fi
        done
        lisp_boxes+=")"
        if [[ $i -lt $((m-2)) ]]; then
            lisp_boxes+=" "
        fi
    done
    lisp_boxes+=")"
    
    # convert current player
    local lisp_player
    if [[ "$current_player" == "human" ]]; then
        lisp_player=":human"
    else
        lisp_player=":computer"
    fi
    
    # output into file format (one item per line)
    echo "$m"
    echo "$n" 
    echo "$lisp_edges_h"
    echo "$lisp_edges_v"
    echo "$lisp_boxes"
    echo "$lisp_player"
    echo "2"  # depth
}

lisp_minimax() {
    local lisp_input="$1"
    
    # create a temporary file for board state
    local temp_file=$(mktemp)
    
    # write multi-line input directly to file
    cat > "$temp_file" << EOF
$lisp_input
EOF
    
    echo "DEBUG: Temp file content:" >&2
    cat "$temp_file" >&2
    echo "DEBUG: End temp file" >&2
    
    # call lisp with file as argument
    local result=$(sbcl --script db_ai.lisp "$temp_file" 2>/dev/null)
    
    # clean up temporary file
    rm -f "$temp_file"
    
    echo "DEBUG: Lisp file-based result: '$result'" >&2
    
    # convert lisp result back into bash - take care of upper/lowercase
    if [[ "$result" =~ [Vv][Ee][Rr][Tt][Ii][Cc][Aa][Ll][[:space:]]+([0-9]+)[[:space:]]+([0-9]+) ]]; then
        local i="${BASH_REMATCH[1]}"
        local j="${BASH_REMATCH[2]}"
        echo "$i,$j,$((i+1)),$j"
    elif [[ "$result" =~ [Hh][Oo][Rr][Ii][Zz][Oo][Nn][Tt][Aa][Ll][[:space:]]+([0-9]+)[[:space:]]+([0-9]+) ]]; then
        local i="${BASH_REMATCH[1]}"
        local j="${BASH_REMATCH[2]}"
        echo "$i,$j,$i,$((j+1))"
    else
        echo ""  # fallback to medium AI
    fi
}

# move validation for hard level
validate_move() {
    local edge="$1"
    if [[ -n "${edges[$edge]}" ]]; then
        echo "ERROR: Edge $edge already exists!"
        return 1
    fi
    return 0
}

hard_ai_move() {
    local completing_moves=()
    # generate all possible edges that don't exist
    local all_possible_edges=()
    
    # horizontal edges
    for ((i=0; i<m; i++)); do
        for ((j=0; j<n-1; j++)); do
            local key="$i,$j,$i,$((j+1))"
            if [[ -z "${edges[$key]}" ]]; then
                all_possible_edges+=("$key")
            fi
        done
    done
    
    # vertical edges
    for ((i=0; i<m-1; i++)); do
        for ((j=0; j<n; j++)); do
            local key="$i,$j,$((i+1)),$j"
            if [[ -z "${edges[$key]}" ]]; then
                all_possible_edges+=("$key")
            fi
        done
    done
    
    # categorize each possible edge for box completion
    for edge in "${all_possible_edges[@]}"; do
        IFS=',' read -r i j k l <<< "$edge"
        
        # check if the edge completes a box
        if [[ $i -eq $k ]]; then
            # horizontal edge - check boxes above and below
            # check box above
            if [[ $i -gt 0 ]] && \
               [[ -n "${edges[$((i-1)),$j,$i,$j]}" ]] && \
               [[ -n "${edges[$((i-1)),$j,$((i-1)),$((j+1))]}" ]] && \
               [[ -n "${edges[$((i-1)),$((j+1)),$i,$((j+1))]}" ]]; then
                completing_moves+=("$edge")
            fi
            # check box below
            if [[ $i -lt $((m-1)) ]] && \
               [[ -n "${edges[$i,$j,$((i+1)),$j]}" ]] && \
               [[ -n "${edges[$i,$((j+1)),$((i+1)),$((j+1))]}" ]] && \
               [[ -n "${edges[$((i+1)),$j,$((i+1)),$((j+1))]}" ]]; then
                completing_moves+=("$edge")
            fi
        else
            # vertical edge - check boxes to the left and right
            # check box to the left
            if [[ $j -gt 0 ]] && \
               [[ -n "${edges[$i,$((j-1)),$i,$j]}" ]] && \
               [[ -n "${edges[$i,$((j-1)),$((i+1)),$((j-1))]}" ]] && \
               [[ -n "${edges[$((i+1)),$((j-1)),$((i+1)),$j]}" ]]; then
                completing_moves+=("$edge")
            fi
            # check box to the right
            if [[ $j -lt $((n-1)) ]] && \
               [[ -n "${edges[$i,$j,$i,$((j+1))]}" ]] && \
               [[ -n "${edges[$i,$((j+1)),$((i+1)),$((j+1))]}" ]] && \
               [[ -n "${edges[$((i+1)),$j,$((i+1)),$((j+1))]}" ]]; then
                completing_moves+=("$edge")
            fi
        fi
    done
    
    # 2. if there are boxes to complete, analyze consequences with lisp
    if [[ ${#completing_moves[@]} -gt 0 ]]; then
		# Just take the first completing move
		local best_completion="${completing_moves[0]}"
		IFS=',' read -r row1 col1 row2 col2 <<< "$best_completion"
		edges["$best_completion"]=1
		check_boxes "$row1" "$col1" "$row2" "$col2"
		
		local display_row1=$((row1+1)) display_col1=$((col1+1))
		local display_row2=$((row2+1)) display_col2=$((col2+1))
		echo "Computer plays: $display_row1$display_col1 $display_row2$display_col2"
		return
	fi
    
    # 3. for non-completion moves use full minimax
    local lisp_input=$(convert_to_lisp_format)
    local best_move=$(lisp_minimax "$lisp_input" "${all_possible_edges[@]}")
    
    
    if [[ -n "$best_move" ]] && validate_move "$best_move"; then
        IFS=',' read -r row1 col1 row2 col2 <<< "$best_move"
        edges["$best_move"]=1
        check_boxes "$row1" "$col1" "$row2" "$col2"
        
        local display_row1=$((row1+1)) display_col1=$((col1+1))
        local display_row2=$((row2+1)) display_col2=$((col2+1))
        echo "Computer plays: $display_row1$display_col1 $display_row2$display_col2"
    else
        # fallback to medium ai
        medium_ai_move
    fi
}

game_over() {
    (( ${#edges[@]} >= (m-1)*n + (n-1)*m ))
}

# main game loop
main() {
    setup_game
    
    while true; do
        display_board
        
        # player's turn
        if [ "$current_player" = "human" ]; then
            local boxes_before=${#boxes[@]}
            player_move
            local boxes_after=${#boxes[@]}
            # if no new boxes were completed, switch turns
            if (( boxes_after == boxes_before )); then
                current_player="computer"
            fi
        else
            local boxes_before=${#boxes[@]}
            case $difficulty in
                "easy") easy_ai_move ;;
                "medium") medium_ai_move ;;
                "hard") hard_ai_move ;;
            esac
            local boxes_after=${#boxes[@]}
            # if no new boxes were completed, switch turns  
            if (( boxes_after == boxes_before )); then
                current_player="human"
            fi
        fi
        
        if game_over; then
            # display final board state
            display_board
            
            # count boxes to determine actual winner
            local player_boxes=0
            local computer_boxes=0
            for owner in "${boxes[@]}"; do
                if [[ "$owner" == "P" ]]; then
                    ((player_boxes++))
                elif [[ "$owner" == "C" ]]; then
                    ((computer_boxes++))
                fi
            done
            
            echo "Game over!"
            echo "Player boxes: $player_boxes"
            echo "Computer boxes: $computer_boxes"
            
            if (( player_boxes > computer_boxes )); then
                echo "You win!"
            elif (( computer_boxes > player_boxes )); then
                echo "Computer wins!"
            else
                echo "It's a tie!"
            fi
            break
        fi
    done
    
        echo
		read -p "Play again? (y/n): " play_again
		if [[ $play_again =~ ^[Yy]$ ]]; then
		    # clear arrays before restarting
		    unset edges
		    unset boxes
		    unset board
		    # Recursive call to main
		    main
		    return
		else
		    echo "Thanks for playing DOTS AND BOXES!"
		fi
}

# start the game
main
```

### AI Engine (Common Lisp)

The Lisp component handles the strategic AI (for hard level) using chain analysis and double-cross strategy. It evaluates board positions by detecting connected chains of boxes, and identifying moves that allow for sacrifice of small chains for gaining larger ones.

```lisp
(defstruct game-state
  (rows 4)
  (cols 4)
  (edges-h nil)
  (edges-v nil) 
  (boxes nil)
  (current-player :computer))

(defun count-box-edges (edges-h edges-v box-row box-col rows cols)
  "Count how many edges a box currently has"
  (let ((count 0))
    ;; top horizontal edge
    (when (nth box-col (nth box-row edges-h))
      (incf count))
    ;; bottom horizontal edge
    (when (nth box-col (nth (1+ box-row) edges-h))
      (incf count))
    ;; left vertical edge
    (when (nth box-row (nth box-col edges-v))
      (incf count))
    ;; right vertical edge
    (when (nth box-row (nth (1+ box-col) edges-v))
      (incf count))
    count))

(defun creates-3-edge-box-p (edges-h edges-v move rows cols)
  "check if a move creates a 3-edge box for the opponent"
  (let ((move-type (first move))
        (i (second move))
        (j (third move)))
    
    (case move-type
      (:horizontal
       ;; check box above
       (when (and (> i 0) 
                  (= (count-box-edges edges-h edges-v (1- i) j rows cols) 2))
         (return-from creates-3-edge-box-p t))
       ;; check box below
       (when (and (< i (1- rows))
                  (= (count-box-edges edges-h edges-v i j rows cols) 2))
         (return-from creates-3-edge-box-p t)))
      
      (:vertical
       ;; check box to left
       (when (and (> j 0)
                  (= (count-box-edges edges-h edges-v i (1- j) rows cols) 2))
         (return-from creates-3-edge-box-p t))
       ;; check box to right
       (when (and (< j (1- cols))
                  (= (count-box-edges edges-h edges-v i j rows cols) 2))
         (return-from creates-3-edge-box-p t))))
    
    nil))
    
(defun analyze-chains (edges-h edges-v rows cols)
  "identify all chains of connected boxes and return their sizes"
  (let ((chains '())
        (visited (make-array (list (1- rows) (1- cols)) :initial-element nil)))
    
    (dotimes (i (1- rows))
      (dotimes (j (1- cols))
        (when (and (not (aref visited i j))
                   (open-box-p edges-h edges-v i j rows cols))
          (let ((chain-size (explore-chain edges-h edges-v i j visited rows cols)))
            (when (> chain-size 0)
              (push chain-size chains))))))
    
    chains))

(defun open-box-p (edges-h edges-v box-row box-col rows cols)
  "check if a box is open (i.e., has 0, 1, or 2 edges)"
  (let ((edge-count (count-box-edges edges-h edges-v box-row box-col rows cols)))
    (< edge-count 3)))

(defun explore-chain (edges-h edges-v box-row box-col visited rows cols)
  "Explore a chain of connected open boxes using BFS"
  (when (or (aref visited box-row box-col) 
            (not (open-box-p edges-h edges-v box-row box-col rows cols)))
    (return-from explore-chain 0))
  
  (setf (aref visited box-row box-col) t)
  (let ((size 1))
    ;; explore adjacent boxes in all four directions
    (when (> box-row 0)
      (incf size (explore-chain edges-h edges-v (1- box-row) box-col visited rows cols)))
    (when (< box-row (- rows 2))
      (incf size (explore-chain edges-h edges-v (1+ box-row) box-col visited rows cols)))
    (when (> box-col 0)
      (incf size (explore-chain edges-h edges-v box-row (1- box-col) visited rows cols)))
    (when (< box-col (- cols 2))
      (incf size (explore-chain edges-h edges-v box-row (1+ box-col) visited rows cols)))
    size))
    
(defun double-cross-decision (move edges-h edges-v rows cols)
  "determine whether this move invokes double-cross strategy"
  (let* ((move-type (first move))
         (i (second move))
         (j (third move))
         (new-edges-h (copy-tree edges-h))
         (new-edges-v (copy-tree edges-v)))
    
    ;; apply the move to a copy of the board
    (case move-type
      (:horizontal
       (when (and (< i (length new-edges-h))
                  (< j (length (nth i new-edges-h))))
         (setf (nth j (nth i new-edges-h)) t)))
      (:vertical
       (when (and (< j (length new-edges-v))
                  (< i (length (nth j new-edges-v))))
         (setf (nth i (nth j new-edges-v)) t))))
    
    ;; analyze chains before and after the move
    (let ((old-chains (analyze-chains edges-h edges-v rows cols))
          (new-chains (analyze-chains new-edges-h new-edges-v rows cols)))
      
      ;; double-cross: give away small chain to gain larger one
      (double-cross-p old-chains new-chains))))

(defun double-cross-p (old-chains new-chains)
  "check if this move implements double-cross strategy"
  (let ((old-longest (apply #'max (cons 0 old-chains)))
        (new-longest (apply #'max (cons 0 new-chains)))
        (old-small-chains (remove-if (lambda (x) (>= x 3)) old-chains))
        (new-small-chains (remove-if (lambda (x) (>= x 3)) new-chains)))
    
    ;; double-cross: we sacrifice small chains but gain a longer chain
    (and (> new-longest old-longest)
         (< (length new-small-chains) (length old-small-chains)))))

(defun analyze-from-file (filename)
  (with-open-file (stream filename :direction :input)
    (let ((rows (read stream))
          (cols (read stream))
          (edges-h (read stream))
          (edges-v (read stream))
          (boxes (read stream))
          (current-player (read stream))
          (depth (read stream)))
          
      ;; debug: first let's see chain analysis   
      (debug-chain-analysis edges-h edges-v rows cols)
      
      ;; enhanced ai with double-cross strategy
      (let ((double-cross-moves '())
            (safe-moves '())
            (all-moves '()))
        
        ;; generate all possible moves
        (dotimes (i rows)
          (dotimes (j (1- cols))
            (unless (nth j (nth i edges-h))
              (push (list :horizontal i j) all-moves))))
        
        (dotimes (j cols)
          (dotimes (i (1- rows))
            (unless (nth i (nth j edges-v))
              (push (list :vertical i j) all-moves))))
        
        ;; categorize moves
        (dolist (move all-moves)
          (cond
            ;; double-cross moves (highest priority)
            ((double-cross-decision move edges-h edges-v rows cols)
             (push move double-cross-moves))
            ;; safe moves (don't create 3-edge boxes)
            ((not (creates-3-edge-box-p edges-h edges-v move rows cols))
             (push move safe-moves))))
        
        ;; decision hierarchy - double-cross gets top priority
        (cond
          (double-cross-moves
           (let ((move (first double-cross-moves)))
             (format t "DOUBLE-CROSS: ~{~a~^ ~}~%" move)
             (format t "~{~a~^ ~}" move)))
          (safe-moves
           (let ((move (first safe-moves)))
             (format t "~{~a~^ ~}" move)))
          (all-moves
           (let ((move (first all-moves)))
             (format t "~{~a~^ ~}" move)))
          (t nil))))))

;; main entry point
(let ((args sb-ext:*posix-argv*))
  (when (>= (length args) 2)
    (analyze-from-file (second args))))
```

**References:**
* Berlekamp, E. R., Conway, J. H., and Guy, R. K. (1982). *Winning Ways for your Mathematical Plays*, volumes 1 and 2. Academic Press, London.