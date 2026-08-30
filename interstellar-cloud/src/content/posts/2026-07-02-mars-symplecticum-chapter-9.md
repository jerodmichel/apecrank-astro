---
title: "SHANNON SWITCHING: Sabotage and Matroids"
pubDatetime: 2026-08-12T00:00:00Z
description: "An exploration of the Shannon Switching Game, matroid theory, and a complete implementation in bash and lisp."
author: "Jerod Michel, Gao Yucheng"
tags: ["bash", "lisp", "combinatorial game theory", "command line", "Shannon Switching", "perfect information", "math"]
---

<blockquote class="text-right ml-auto max-w-2xl italic mb-8 !border-none !pl-0 before:content-none after:content-none [quotes:none]">
  <p>"The fundamental principle of war is to operate upon the communications of the enemy without exposing one's own."</p>
  <p class="font-bold mt-2">— Antoine-Henri Jomini, Summary of the Art of War (1838)</p>
</blockquote>

## Description

Despite its abstract setting, the Shannon Switching Game is a foundational contest of connection and disconnection with guaranteed winning strategy determined by spanning tree connectivity. The optimal strategy relies on matroid theory and structural pairing arguments, allowing a first player to dynamically preserve safe paths regardless of the opponent's cuts.

In essence, the Shannon Switching Game generalizes network topology and graph theory, serving as a master blueprint for all connection-based board games and demonstrating how structural dualities dictate inevitable victory.

## History

The origins of Shannon Switching are rooted in the cold, hard logic of Cold War-era telecommunications. Invented in 1953 by Claude Shannon—the father of information theory—at Bell Labs, it was conceived as a mathematical duel between two forces: connection and destruction (often formalized as Short and Cut). Shannon was stress-testing the vulnerability of communications grids, and the pure, zero-sum struggle for topological dominance over a network.

**SHANNON'S ANALOG MACHINE (1953):** Shannon didn't just theorize the game, but built a physical machine to play it. Constructed from a Frankenstein network of resistors and relays, the custom-built machine literally measured the path of least electrical resistance to determine the optimal move. It was an analog beast that played the role of "Short," relentlessly seeking paths through the circuit no matter what wires have been severed already.

**THE GALE CONNECTION (1958):** The underlying mechanics of this network warfare were independently formulated by mathematician David Gale. Gale's variation, played on a regular grid, captured the exact same partisan asymmetry and became a cornerstone of algorithmic game theory. While it was eventually marketed to the masses as a harmless board game called Bridg-It, its DNA remained fundamentally tied to Shannon's electrical networks.

**LEHMAN'S MATROID SOLUTION (1964):** Alfred Lehman finally cracked the game's underlying genetic code using Matroid Theory. He showed that the optimal strategy wasn't about looking ahead in a traditional game tree, but evaluating the structural integrity of the network itself. It was a definitive triumph that turned a game of deliberate sabotage into a solved problem of structural engineering.

## Rules and Gameplay

Shannon Switching is a two-player game played on a finite graph having two distinguished vertices, often referred to as *terminals*. The players are called, traditionally, *Short* (seeking connection) and *Cut* (seeking disconnection). The game is a pure contest of topological control over a shared network.

**The Board.** The board consists of a finite, undirected multigraph. Two specific nodes are designated as the terminal nodes (denoted as $A$ and $B$). The edges of the graph represent potential links or communication lines between nodes. Initially, all edges in the network are neutral, and available to be acted upon by either player.

**Legal Moves.** A move consists of modifying the state of exactly one available edge in the graph. Short, on a move, permanently secures an edge, making it immune to deletion (conceptually "shorting" the connection, or coloring the edge to represent its indestructibility). Cut, on a move, permanently deletes an available edge. Once an edge is secured by Short or deleted by Cut, it becomes fixed in the resulting state, and cannot be altered by either player.

**Turn Order and Passing.** Players alternate turns. Which player moves first is determined prior to the game (either player can logically be assigned the first move, changing the strategic evaluation of the graph). *Passing is prohibited*; a player must move on their turn.

**Termination and Victory.** The game is strictly finite as there are finitely many edges in the initial graph, and one edge is resolved per turn. Play continues until a victory condition is met. Short wins immediately once a continuous, unbroken path of protected edges is secured connecting terminal $A$ to terminal $B$. Cut wins immediately once all possible paths between the terminals have been eliminated, rendering them permanently disconnected. Since any fully resolved graph must either contain a connected path or be definitively severed, a draw is impossible.

## Mathematics of Shannon Switching

### Formalizing the Game Graph

To analyze Shannon Switching, we must strip away all physical analogies of wires and relays, and use a graph-theoretic foundation. This allows us to map sequential actions by Short or by Cut into a *state space* that can be treated mathematically.

![Figure 1: Typical Shannon Switching board; a general multigraph with two terminals, s and t. All edges shown are currently free (unclaimed).](/ss0.png)

#### Graph-Theoretic Foundation

Recall that a multigraph is a graph in which there may be more than one edge between a pair of vertices. We will need the following definitions.

<div class="definition">

**Definition (The Game Graph).**

Let the game board be defined as a finite, undirected multigraph $G = (V, E)$. Let $s, t \in V$ be two distinguished vertices called *terminals*. Note that loops are irrelevant to connectivity and can be ignored.

</div>

At any point during the game, the edge set $E$ can be partitioned into three mutually disjoint subsets:
*   $E_F$: The set of *free* (unclaimed) edges.
*   $E_S$: The set of edges secured by *Short*.
*   $E_C$: The set of edges (permanently) deleted by *Cut*.

Initially, $E_F = E$, and $E_S = E_C = \emptyset$.

<div class="definition">

**Definition (Winning Conditions).**

Also recall that a *path* is a sequence of distinct vertices $v_0, v_1, \dots, v_k$ such that for each $0 \le i < k$, there is an edge between $v_i$ and $v_{i+1}$.

**Short's Victory:** Short wins if and only if there exists a path from $s$ to $t$ consisting entirely of edges in $E_S$.

**Cut's Victory:** Cut wins if and only if there exists no path from $s$ to $t$ in the subgraph $(V, E \setminus E_C)$. Equivalently, Cut wins if $E_C$ contains an edge cut disconnecting $s$ from $t$ (see Chapter 8, Definition 4.4).

</div>

#### Partial Order of Positions

As edges, once claimed or deleted, cannot be altered, Shannon Switching is strictly monotonic. We therefore can formalize this by defining a partial order over all possible game states.

<div class="definition">

**Definition (Game Position and Monotonicity).**

We let a *position* in the game be defined by the tuple $P = (E_S, E_C, E_F)$, and define a partial order on positions so that $P \le Q$ (read as "$Q$ is at least as favorable for Short as $P$") if and only if:
$$
E_S(P) \subseteq E_S(Q) \quad \text{and} \quad E_C(P) \supseteq E_C(Q).
$$


</div>

<div class="theorem">

**Lemma (The Monotonicity Principle).**

If Short has a winning strategy from position $P$, and $P \le Q$, then Short also has a winning strategy from position $Q$. Conversely, if Cut has a winning strategy from $Q$, and $P \le Q$, Cut has a winning strategy from $P$.

</div>

<div class="proof">

**Proof.**

Assume that conditions and suppose that Short has a winning strategy $\mathcal{S}$ from position $P$. In position $Q$, Short possesses all the secured edges they had in $P$, and Cut has strictly fewer deleted edges. If Short plays according to $\mathcal{S}$ from position $Q$, any edge required by $\mathcal{S}$ that Short has already secured in $Q$ can simply be treated as a "pass" (or Short can secure an arbitrary free edge, which by definition cannot hurt their position). Any edge Cut could have deleted in $P$ but hasn't in $Q$ only leaves more options for Short. Since $G$ is finite, Short will complete the path from $s$ to $t$ form position $Q$ at least as fast as from position $P$. The proof for Cut's advantage is similar.
<div class="text-right">&#9633;</div>

</div>

### The Central Theorem: Lehman's Characterization

The foundational breakthrough in Shannon Switching was achieved by Alfred Lehman in 1964. Lehman proved that the game is not merely a sequence of tactical lookaheads, but that its positions are deterministic outcome dictated entirely by its static topological structure.

#### Statement of Lehman's Theorem

To make analysis elegant, we introduce an artificial edge $e^* = (s, t)$ connecting the terminals. For graph-theoretic definitions of paths and cycles, the reader is referred to Chapter 3; for that of spanning trees, to Chapter 8. Short's goal of connecting $s$ to $t$ is then equivalent to forming a cycle which includes $e^*$. Lehman analyzed the game where Short plays *second*, providing the strict criteria for a network's absolute resilience.

<div class="theorem">

**Theorem (Lehman's Theorem).**

In a Shannon Switching graph $G = (V,E)$ with terminals $s$ and $t$, Short (playing second) has a winning strategy if and only if there exists a subset of vertices $U \subseteq V$ containing both $s$ and $t$, such that the induced subgraph $G[U]$ contains two edge-disjoint spanning trees.

</div>

<div class="theorem">

**Corollary (First-Player Advantage).**

Since Shannon Switching is monotonic, Short playing *first* has a winning strategy if and only if there exists a single edge $e \in E$ such that securing $e$ (which effectively contracts the edge) results in a graph where Short playing second has a winning strategy.

</div>

#### Intuition and Consequences

Why is the existence of two edge-disjoint spanning trees the threshold? The intuition lies in the concept of a *pairing strategy*.

If a subset of the network containing the terminals is supported by two entirely disjoint spanning trees, $T_1$ and $T_2$, Short must have a built-in redundancy. A spanning tree provides exactly one path between any two vertices. By having two disjoint trees, every time Cut severs a branch of $T_1$, the tree is split into two disconnected components. However, since $T_2$ also spans the exact same vertices, $T_2$ is guaranteed to contain an edge bridging these two broken components. Short's strategy then is simply to immediately secure that bridge.

Lehman's Theorem shifts the computation of the game from an adversarial search algorithm (such as Minimax) to polynomial-time algorithms on graph structure.

#### Rigorous Proof of Lehman's Theorem

To prove Lehman's statement, we must show both sufficiency (that two trees guarantee a win for Short) and necessity (that absent these two trees, cut is guaranteed a win). We will need the following lemma whose proof is, unfortunately, beyond our scope.

<div class="theorem">

**Lemma (Tutte / Nash-Williams).**

A multigraph $H = (V_H, E_H)$ contains $k$ edge-disjoint spanning trees if and only if for every partition $\mathcal{P}$ of the vertex set $V_H$, the number of edges crossing between different parts of the partition is at least $k(|\mathcal{P}| - 1)$.

</div>

<div class="proof">

**Proof (Sufficiency).**

Assume there exists $U \subseteq V$ with $s, t \in U$, such that the induced subgraph $G[U]$ contains two edge-disjoint spanning trees, $T_1$ and $T_2$. We must construct a winning strategy for Short playing second.

Let Short restrict their play entirely to the edges in $E' = E(T_1) \cup E(T_2)$. Since $T_1$ and $T_2$ are trees spanning $U$, $|E(T_1)| = |E(T_2)| = |U| - 1$.

Short's strategy relies on maintaining a protected spanning tree of $U$. We may take $T_1$ as the initial "target" tree, and $T_2$ as the "reserve" tree. Now suppose that Cut deletes an edge $e$. If $e \notin E'$, Short can simply secure an arbitrary free edge in $E'$ (or pass, conceptually, by securing an edge outside of $E'$).

If Cut deletes an edge $e \in T_1$, the tree $T_1$ then splits into two disconnected components, $C_1$ and $C_2$, partitioning $U$. Since $T_2$ spans $U$, it must contain at least one edge $f$ connecting $C_1$ to $C_2$. Short then immediately secures $f$, thereby defining the new target tree $T_1' = (T_1 \setminus \{e\}) \cup \{f\}$, and new reserve tree $T_2' = T_2 \setminus \{f\}$.

Notice that $T_1'$ is a valid spanning tree of $U$, and that $T_2'$ is a collection of disjoint trees (i.e., a *forest*) and potential reserve for future cuts. Thus, by continually pairing Cut's deletions in the target tree with bridging edges from the reserve tree, Short guarantees the target tree remains connected. As both $s$ and $t$ are in $U$, and Short maintains a spanning tree of $U$ using only secured edges, Short is guaranteed completion of a path from $s$ to $t$.
<div class="text-right">&#9633;</div>

</div>

![Figure 2: A multigraph whose edges are partitioned into two edge-disjoint spanning trees: T_1 (solid blue) and T_2 (dashed orange). Short can always maintain connectivity by pairing edges across these two structures.](/ss1.png)

<div class="proof">

**Proof (Necessity).**

Assume Short has a winning strategy playing second. We must show there exists a subset $U\subseteq V$ containing both $s$ and $t$, and that $G \left[ U \right]$ contains two edge-disjoint spanning trees. Proceed by contrapositive, we suppose no such subset $U$ exists, and show that Cut must have a winning strategy.

By Lemma 4.3, absence of the two edge-disjoint spanning trees in any subgraph containing both $s$ and $t$ implies that for any subset $U$ containing the terminals, there must exist a partition $\mathcal{P}$ of $U$ such that the number of edges crossing the partition is strictly less than $2(|\mathcal{P}| - 1)$.

Then let Cut adopt the strategy of restricting edge deletions exclusively to edges crossing the vulnerable partition $\mathcal{P}$. Since the total number of crossing edges is strictly less than $2(|\mathcal{P}| - 1)$, Cut can systematically sever the connections between the parts of $\mathcal{P}$ faster than Short can secure a spanning configuration across them.

Eventually, Cut will isolate a component containing $s$ from the component containing $t$, permanently disconnecting the terminals. Thus, as the condition is not met, Cut must win.
<div class="text-right">&#9633;</div>

</div>

### Matroid Theory and the Shannon Switching Game

While graph theory provides the visual intuition for Lehman's Theorem, the true algebraic backbone of Shannon Switching lies in matroid theory, which abstracts the concept of linear independence from a vector space to a graph, and reveals the symmetry between Short and Cut.

#### Introduction to Matroids

<div class="definition">

**Definition (Matroid).**

A finite matroid $M = (E, \mathcal{I})$ consists of a finite set $E$ (the ground set) and a collection $\mathcal{I}$ of subsets of $E$, called *independent sets*, such that:
1.  $\emptyset \in \mathcal{I}$,
2.  (Hereditary Property) if $I \in \mathcal{I}$ and $I' \subset I$, then $I' \in \mathcal{I}$, and
3.  (Exchange Property) if $I_1, I_2 \in \mathcal{I}$ and $|I_1| < |I_2|$, there exists $e \in I_2 \setminus I_1$ such that $I_1 \cup \{e\} \in \mathcal{I}$.

</div>

In the context of Shannon Switching, we use the *graphic matroid* (or cycle matroid) $M(G)$ of the graph $G$.

Let $E$ be the edge set of $G$. A subset $I \subseteq E$ is *independent* if it contains no cycle (i.e., $I$ forms a forest). A maximal independent set in a connected graph is a spanning tree which, in matroid terminology, is called a *basis*.

#### The Duality of Short and Cut

Short's objective is to secure a path between $s$ and $t$. If we append the artificial edge $e^* = (s, t)$, Short's goal then becomes securing a set of edges that, together with $e^*$, form a cycle. In matroid terms, Short wants to force $e^*$ to be part of a *circuit* (a minimal dependent set) of Short's secured edges.

Cut, on the other hand, wants to disconnect $s$ from $t$. Cut's goal is to delete a set of edges that form an edge cut that disconnects $s$ from $t$.

This a profound symmetry via the *dual matroid* $M^*$.

<div class="definition">

**Definition (Dual Matroid).**

Given a matroid $M = (E, \mathcal{I})$ with bases $\mathcal{B}$, the dual matroid $M^* = (E, \mathcal{I}^*)$ has bases $\mathcal{B}^* = \{ E \setminus B \mid B \in \mathcal{B} \}$. The collection of independent sets $\mathcal{I}^*$ consists of all subsets of the dual bases in $\mathcal{B}^*$.

</div>

In the graphic matroid $M(G)$, a circuit is a cycle. In the dual matroid $M^*(G)$, a circuit corresponds to an *edge cut* of $G$ (i.e., a minimal set of edges whose removal increases the number of connected components).

To prove that this game must always produce a winner, we rely on a foundational property of matroid duality.

<div class="definition">

**Definition (Matroid Rank).**

For a matroid $M = (E, \mathcal{I})$, the *rank function* $r: 2^E \to \mathbb{Z}_{\ge 0}$ assigns to each subset $A \subseteq E$ the size of the largest independent set contained within $A$.

An element $e \in A$ is part of a circuit within $A$ if and only if its removal does not decrease the rank of the set, i.e., $r(A) = r(A \setminus \{e\})$.

</div>

One consequence of this duality is that the rank function of the dual matroid, $M^*$, can be explicitly calculated directly from the rank function of $M$. For any subset $A \subseteq E$, the dual rank function $r^*$ is given by:
$$
r^*(A) = |A| + r(E \setminus A) - r(E).
$$


Now the impossibility of a draw becomes a strict algebraic certainty, and is formalized in the following lemma, often attributed to George Minty.

<div class="theorem">

**Lemma (Circuit-Cocircuit Lemma).**

Let $M$ be a matroid on a ground set $E$, and let $e^* \in E$. For any partition of the remaining members $E \setminus \{e^*\}$ into two disjoint sets $X$ and $Y$, exactly one of the following occurs:
*   $X \cup \{e^*\}$ contains a circuit of $M$ that includes $e^*$, or
*   $Y \cup \{e^*\}$ contains a circuit of $M^*$ that includes $e^*$.

</div>

<div class="proof">

**Proof.**

By definition, $e^*$ is contained in a circuit of $M$ within $X \cup \{e^*\}$ if and only if
$$
r(X \cup \{e^*\}) = r(X).
$$

Similarly, $e^*$ is contained in a circuit of $M^*$ within $Y \cup \{e^*\}$ if and only if
$$
r^*(Y \cup \{e^*\}) = r^*(Y).
$$

We can now evaluate the dual rank condition using the dual rank formula. Consider the difference $r^*(Y \cup \{e^*\}) - r^*(Y)$. We have
$$
\begin{align*}
r^*(Y \cup \{e^*\}) - r^*(Y) &= \left( |Y \cup \{e^*\}| + r(E \setminus (Y \cup \{e^*\})) - r(E) \right) \\
&\quad - \left( |Y| + r(E \setminus Y) - r(E) \right).
\end{align*}
$$

Since $X$ and $Y$ partition $E \setminus \{e^*\}$, we must have $E \setminus (Y \cup \{e^*\}) = X$ and $E \setminus Y = X \cup \{e^*\}$. Moreover, $|Y \cup \{e^*\}| - |Y| = 1$. Substituting these into the equation simplifies it to:
$$
r^*(Y \cup \{e^*\}) - r^*(Y) = 1 + r(X) - r(X \cup \{e^*\}),
$$

whence
$$
r^*(Y \cup \{e^*\}) - r^*(Y) + r(X \cup \{e^*\}) - r(X) = 1.
$$

Because adding a single element to a set can increase its rank by at most 1, both differences on the left side of the equation must be either $0$ or $1$. Since their sum is exactly $1$, one of the differences must be $0$, and the other must be $1$.

Therefore, exactly one of the two rank conditions holds.
<div class="text-right">&#9633;</div>

</div>

#### Pairing Strategies as Matroid Matchings

The abstract existence of two edge-disjoint spanning trees guarantees a victory for Short, but the tactical execution requires translating this structure into a dynamic pairing strategy. This is achieved via the basis exchange properties of matroids.

Let $T_1$ and $T_2$ be two edge-disjoint spanning trees of the game graph $G$ (or the relevant induced subgraph containing the terminals). In the graphic matroid $M(G)$, $T_1$ and $T_2$ are disjoint bases. The *Base Exchange Theorem* dictates that for any element $e \in T_1$, there exists an element $f \in T_2$ such that the set $(T_1 \setminus \{e\}) \cup \{f\}$ is also a basis (a valid spanning tree).

Short designates $T_1$ as the primary connection tree and $T_2$ as the reserve tree. Whenever Cut deletes an edge $e$, if $e \in T_1$, Short identifies the guaranteed exchange edge $f \in T_2$, secures it, and updates the primary tree to $T_1' = (T_1 \setminus \{e\}) \cup \{f\}$ and the reserve to $T_2' = T_2 \setminus \{f\}$. Because $T_1$ and $T_2$ initially share no edges, Cut can never simultaneously sever both $e$ and $f$. This bijective matching ensures Short can always repair any fracture Cut introduces, permanently preserving connectivity.

#### The Role of the Dual Matroid

While Short operates on the graphic matroid $M(G)$, Cut operates on the dual matroid $M^*(G)$. Cut's objective—severing all paths between $s$ and $t$—is equivalent to constructing a circuit in $M^*(G)$ that contains the artificial terminal edge $e^*$.

This establishes a perfect mathematical symmetry. A basis in $M^*(G)$ corresponds to the complement of a spanning tree in $G$ (a *cotree*). By Lehman's Theorem, just as Short (playing second) wins if and only if $M(G)$ contains two disjoint bases, Cut (playing second) wins if and only if the dual matroid $M^*(G)$ contains two disjoint bases.

Thus, the game's outcome is not determined by tactical brilliance, but by whether the graph's edge density favors the primal matroid (sufficiently dense, favoring Short) or the dual matroid (sufficiently sparse, favoring Cut).

#### Constructive Execution of the Pairing Strategy

While the abstract properties of matroids guarantee that an exchange edge exists, translating this into a playable strategy requires a constructive proof. As detailed in [WW82], the exact mechanics of the pairing strategy can be derived purely from graph topology using fundamental cut-sets.

<div class="definition">

**Definition (Fundamental Cut-Set).**

Let $T$ be a spanning tree of a connected graph $G = (V,E)$. For an edge $e \in T$, the removal of $e$ disconnects $T$, partitioning the vertex set $V$ into two disjoint subsets, $V_1$ and $V_2$. The *fundamental cut-set* of $e$ with respect to $T$, denoted $C(e, T)$, is the set of all edges in $E$ that have one endpoint in $V_1$ and the other in $V_2$.

</div>

By definition, to reconnect $V_1$ and $V_2$ and restore the spanning tree, an edge from $C(e, T)$ must be secured. Here we show constructively that Short can always find such an edge in their reserve tree.

<div class="theorem">

**Theorem (Constructive Base Exchange).**

Let $U \subseteq V$, and $T_1$ and $T_2$ be edge-disjoint spanning trees of the induced subgraph $G[U]$. If Cut deletes an edge $e \in T_1$, then the intersection of the fundamental cut-set $C(e, T_1)$ with the reserve tree $T_2$ is non-empty.

</div>

<div class="proof">

**Proof.**

Assuming the conditions, the deletion of $e$ from $T_1$ partitions the vertices of $U$ into two disjoint sets, $U_1$ and $U_2$. Since $T_2$ is also a spanning tree of $U$, there must exist a unique path in $T_2$ between any vertex in $U_1$ and any vertex in $U_2$. For a continuous path to begin in $U_1$ and end in $U_2$, at least one edge of that path must cross this partition.

Let $f$ be this crossing edge. Since $f$ has one endpoint in $U_1$ and the other in $U_2$, $f \in C(e, T_1)$. Moreover, since $f \in E(T_2)$, and $T_1$ and $T_2$ are mutually disjoint, $f$ is a free (unclaimed) edge. Therefore, Short can constructively identify the replacement edge by evaluating $C(e, T_1) \cap E(T_2)$, secure $f$, and legally form the new spanning tree $T_1' = (T_1 \setminus \{e\}) \cup \{f\}$.
<div class="text-right">&#9633;</div>

</div>

This theorem provides the exact mathematical mechanism for Short's defense when playing second on a resilient graph. However, we must also constructively define Short's optimal play when moving *first* on a graph that initially lacks the two disjoint spanning trees (a "Neutral" game, in the terminology of [WW82]). We will use the following terminology.

Let $G = (V, E)$ be a multigraph and let $e \in E$ have endpoints $u$ and $v$. The *edge contraction* of $e$, denoted $G / e$, is the multigraph obtained by removing $e$, merging $u$ and $v$ into a single new vertex, and reattaching all edges previously incident to $u$ or $v$ to this new vertex. (Note that, if either $u$ or $v$ is a terminal vertex, the newly merged vertex inherits that designation.) A graph $H$ is called a *minor* of $G$ if it can be derived from $G$ through any sequence of edge deletions, vertex deletions, or edge contractions.

<div class="theorem">

**Theorem (The First-Move Reduction).**

If Short plays first on a graph $G = (V, E)$, Short possesses a winning strategy if and only if there exists an edge $e_0 \in E$ such that the contraction on $e_0$ results in a multigraph $G / e_0$ containing a vertex subset $U$ where:
1.  $U$ contains the terminals of $G / e_0$, and
2.  the induced subgraph $(G / e_0)[U]$ contains two edge-disjoint spanning trees.

</div>

<div class="proof">

**Proof.**

When Short secures an edge $e_0 = (u, v)$, it effectively fuses vertices $u$ and $v$ together (from the perspective of connectivity), as the path between them can never be severed by Cut. This is identical to the graph operation of edge contraction, and yields the minor $G / e_0$.

Once $e_0$ is secured, the turn passes to Cut. The game is now topologically identical to a game played on $G / e_0$ where Cut moves first (or, where Short moves second). By Theorem 4.1, Short playing second on $G / e_0$ is guaranteed a win if and only if the vertex set contains a subset that contains the terminals, and which induces two edge-disjoint spanning trees. Thus, Short's constructive first move is to identify an edge $e_0$ whose contraction satisfies Lehman's condition, secure it, and proceed with the constructive base exchange strategy on the resulting minor.
<div class="text-right">&#9633;</div>

</div>

## Example of Gameplay

### Setup

To see Lehman's constructive pairing strategy in action, let us examine a game played on a simple multigraph designed to be highly resilient. Let $G=(V, E)$ be this multigraph, with $E$ and $V$ as shown in Figure 3, and $s$ and $t$ acting as terminals.

![Figure 3: Multigraph G prior to decomposition, with all six edges (e_1 through e_6) are available to be claimed by Short or deleted by Cut.](/ss2.png)

Assuming Short is playing second, to guarantee a win, Short first verifies Lehman's condition by decomposing the edges into two edge-disjoint spanning trees, $T_1$ (the primary target tree) and $T_2$ (the reserve tree):

*   **Target Tree ($T_1$)**: $e_1=(s,u)$, $e_3=(u,v)$, and $e_5=(v,t)$.
*   **Reserve Tree ($T_2$)**: $e_6=(s,u)$, $e_2=(s,v)$, and $e_4=(u,t)$.

Notice $e_1$ and $e_6$ are parallel edges connecting the same two vertices, which is perfectly legal in Shannon Switching. Figure 4 gives this initial decomposition.

![Figure 4: The initial state of the game. The solid blue edges form the primary spanning tree T_1, and the dashed orange edges form the disjoint reserve spanning tree T_2.](/ss3.png)

### Executing the Base Exchange

**Turn 1 (Cut):** Cut moves first and attempts to sever the primary tree $T_1$ directly down the middle by deleting edge $e_3$.

**Turn 1 (Short):** Short must repair $T_1$, and so utilizes the constructive base exchange strategy by evaluating the fundamental cut-set $C(e_3, T_1)$.

Removing $e_3$ from $T_1$ partitions the vertices of $G$ into two disconnected sets: $U_1 = \{s, u\}$ (connected by $e_1$) and $U_2 = \{v, t\}$ (connected by $e_5$). Short must then find an edge in the reserve tree $T_2$ that bridges $U_1$ with $U_2$. Examining the edges of $T_2$, we have:
*   $e_6 = (s,u)$ connects two vertices within $U_1$, (Does not cross)
*   $e_2 = (s,v)$ connects $s \in U_1$ to $v \in U_2$, (**Crosses the cut**)
*   $e_4 = (u,t)$ connects $u \in U_1$ to $t \in U_2$. (**Crosses the cut**)

Short discovers that $C(e_3, T_1) \cap E(T_2) = \{e_2, e_4\}$. Since Theorem 4.8 guarantees this intersection to be non-empty, Short can (arbitrarily) choose to secure $e_2$.

Immediately updating the internal trees, Short's new primary tree becomes $T_1' = \{e_1, e_5, e_2\}$, which again successfully spans $G$. The new reserve tree becomes the forest $T_2' = \{e_6, e_4\}$. This new state is shown in Figure 5.

![Figure 5: State after Turn 1. Cut has deleted e_3 (dotted red). Short has repaired the fracture by calculating the fundamental cut-set and securing e_2 (double green) from the reserve tree, restoring T_1'.](/ss4.png)

### Securing the Victory

**Turn 2 (Cut):** Cut realizes the right flank is solidifying and so attacks left, deleting $e_1 \in T_1'$.

**Turn 2 (Short):** Short repeats the topological check. Removing $e_1$ from $T_1'$ splits the vertices into $U_1 = \{u\}$ and $U_2 = \{s, v, t\}$. Short then evaluates the remaining reserve tree $T_2' = \{e_6, e_4\}$. Notice:
*   $e_6 = (s,u)$ connects $u \in U_1$ to $s \in U_2$, (**Crosses the cut**)
*   $e_4 = (u,t)$ connects $u \in U_1$ to $t \in U_2$. (**Crosses the cut**)

Both reserve edges cross the fundamental cut. Short secures $e_4$. The primary tree then updates to $T_1'' = \{e_5, e_2, e_4\}$.

At this point, Short has completely outmaneuvered Cut. Short has secured edges $e_2$ and $e_4$. Since $e_5 \in T_1''$ is still unclaimed, Short has not yet connected $s$ and $t$ exclusively with secured edges. However, the remaining reserve tree $T_2''$ contains $e_6$, and no matter what Cut deletes on Turn 3, Short is guaranteed to secure a path on the subsequent response, demonstrating the absolute resilience provided by Theorem 4.1.

## Shannon Switching in Command Line (with Lisp for game engines)

Moving from multigraphs to a playable digital arena requires a somewhat robust architecture. Since Shannon Switching is played on generalized networks rather than rigid grids, our engine cannot rely on simple 2D arrays. Instead, we must maintain an active list of nodes, explicitly define their coordinate geometry for rendering, and track a mutable list of edges.

### Foundational Algorithms

We will fuse together the same two algorithms as in Chapter 8.

First, we rely on Minimax algorithm (introduced in Chapter 4) to look ahead into the game tree. Since the branching factor of Shannon Switching on dense graphs (such as the Petersen graph) is exceptionally high, our engine restricts Minimax to a depth of two plies. This simulates every available free edge it can claim, and then assumes that the opponent will respond with its best possible counter-move. It then selects the edge that leaves the opponent in the worst resulting state.

To determine exactly what constitutes a "good" or "bad" position, Minimax requires a heuristic evaluator. For this we employ Dijkstra's algorithm (introduced in Chapter 8). Whenever the AI needs to evaluate a board, it runs a shortest path search from the starting terminal $s$ through to the target terminal $t$.
*   When evaluating for Short, an already secured edge has a cost of $0$, a free edge has a cost of $1$ (requiring one turn to secure), and a severed edge has a cost of $999$ (impassable).
*   Cut seeks to maximize this exact cost, pushing the shortest path distance to infinity.

As was also discussed in Chapter 8, to prevent the horizon effect—where multiple moves might leave the shortest path at the exact same distance—Dijkstra also calculates the total network volume (the sum of distances to all reachable nodes). This acts as a tie-breaker, forcing Cut to systematically dismantle the entire web rather than merely delaying a single path.

### Architectural Overview

Following the paradigm established in our Gale implementation, the Shannon Switching engine operates as an optimized, standalone Common Lisp engine, utilizing the terminal for I/O while generating dynamic vector graphics for state visualization.

**Common Lisp (SBCL):** The core engine handles all state representation and heavy computational logic, including:
*   Maintaining the explicit coordinate geometry of the network topology, utilizing curve offsets for parallel edges.
*   Executing BFS traversals for win condition detection (verifying $s-t$ connectivity or absolute network severance).
*   Driving the Hard AI tier via Dijkstra shortest-path evaluations combined with 2-ply Minimax decision trees.
*   Atomic rendering of the board state directly to SVG format, dynamically calculating tangent vectors to prevent label collisions.

### Game Orchestration (Bash)

Acting as the bare-metal director and visual coordinator, the orchestrator script provides a clean, ANSI-colored terminal menu to capture the parameters of engagement (graph topology, AI difficulty, player role, and turn order). It pipes these configuration flags as POSIX arguments directly into the Lisp script, while managing the external image viewer (`eog`) in a background process to continuously live-update the output. When the Lisp process terminates upon a win condition, Bash gracefully catches the exit, cleans up the viewer, and returns the user to the main menu.

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

# Initial State Variables
GRAPH_TYPE=1 
GRAPH_LABEL="K4 Complete Graph"
DIFFICULTY="Hard"
STRATEGY="Lehman's Base Exchange"
PLAYER_ROLE="Short"   # Options: Short, Cut, Random
TURN_ORDER="First"    # Options: First, Second, Random

# clear screen function
clear_screen() {
    printf "\033c"
}

# print the header
print_header() {
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${CYAN}       S H A N N O N   S W I T C H I N G ${NC}"
    echo -e "${CYAN}=========================================${NC}"
    echo -e "Graph Type: ${YELLOW}${GRAPH_LABEL}${NC} | Difficulty: ${YELLOW}${DIFFICULTY}${NC} (${STRATEGY})"
    echo -e "Human Plays: ${YELLOW}${PLAYER_ROLE}${NC} | Turn: ${YELLOW}${TURN_ORDER}${NC}"
    echo -e "${CYAN}-----------------------------------------${NC}"
}

# launch game
start_game() {
    clear_screen
    echo -e "${GREEN}Initializing Lisp Engine...${NC}"
    echo -e "Starting on ${GRAPH_LABEL} using ${STRATEGY}."
    echo -e "Watch the eog window for the board state!\n"
    
    # touch SVG file so eog can open immediately
    rm -f current_shannon_board.svg
    touch current_shannon_board.svg
    
    # launch eog in background. (eog auto-reloads when file changes)
    eog current_shannon_board.svg > eog_error.log 2>&1 &
    EOG_PID=$!

    # 1. Translate ACTUAL_ROLE string into numeric human player ID (1=Short, 2=Cut)
    HUMAN_PLAYER=1
    if [ "$ACTUAL_ROLE" == "Cut" ]; then
        HUMAN_PLAYER=2
    fi

    # 2. Translate ACTUAL_TURN string to determine which numeric ID starts
    START_PLAYER=1
    if [ "$ACTUAL_TURN" == "First" ]; then
        START_PLAYER=$HUMAN_PLAYER
    else
        # If Human is Second, Start Player is the opponent
        if [ "$HUMAN_PLAYER" -eq 1 ]; then
            START_PLAYER=2
        else
            START_PLAYER=1
        fi
    fi

    # 3. Translate DIFFICULTY string to numeric ID
    DIFF_NUM=3
    if [ "$DIFFICULTY" == "Easy" ]; then DIFF_NUM=1; fi
    if [ "$DIFFICULTY" == "Medium" ]; then DIFF_NUM=2; fi

    # Display instructions based on role
    if [ "$ACTUAL_ROLE" == "Short" ]; then
        echo -e "${YELLOW}You are SHORT. Your goal is to CONNECT the terminals (s and t).${NC}"
    else
        echo -e "${YELLOW}You are CUT. Your goal is to DISCONNECT the terminals (s from t).${NC}"
    fi
    echo -e "${YELLOW}Enter your moves by specifying the edge ID (e.g., 1 for e1).${NC}"
    echo -e "${YELLOW}Press Ctrl+D if you wish to exit early.${NC}\n"
    
    # Pass ALL 4 arguments to Lisp engine
    sbcl --script shannon-engine.lisp $GRAPH_TYPE $DIFF_NUM $HUMAN_PLAYER $START_PLAYER 2> engine_error.log
    
    echo -e "\n${GREEN}Game Over!${NC}"
    read -p "Press Enter to return to the main menu..."

    kill $EOG_PID 2>/dev/null
}

# main menu loop
while true; do
    clear_screen
    print_header
    echo "1) Start Game"
    echo "2) Set Graph Topology"
    echo "3) Set Difficulty"
    echo "4) Set Player Role (Short / Cut)"
    echo "5) Set Turn Order (First / Second)"
    echo "6) Exit"
    echo -e "${CYAN}-----------------------------------------${NC}"
    read -p "Select an option [1-6]: " choice

    case $choice in
        1)
            # handle random coin flips right before start
            ACTUAL_ROLE=$PLAYER_ROLE
            if [ "$ACTUAL_ROLE" == "Random" ]; then
                if [ $((RANDOM % 2)) -eq 0 ]; then ACTUAL_ROLE="Short"; else ACTUAL_ROLE="Cut"; fi
                echo -e "${GREEN}Random Role: You are playing as ${ACTUAL_ROLE}!${NC}"
                sleep 1
            fi
            
            ACTUAL_TURN=$TURN_ORDER
            if [ "$ACTUAL_TURN" == "Random" ]; then
                if [ $((RANDOM % 2)) -eq 0 ]; then ACTUAL_TURN="First"; else ACTUAL_TURN="Second"; fi
                echo -e "${GREEN}Random Turn: You are going ${ACTUAL_TURN}!${NC}"
                sleep 1
            fi
            
            start_game
            ;;
        2)
            echo -e "\n${YELLOW}Select Graph Topology:${NC}"
            echo "1) K4 (Complete Graph - 4 Vertices, 6 Edges)"
            echo "2) Wheel Graph W5 (5 Vertices, 8 Edges)"
            echo "3) Resilient Network (Guaranteed 2 Edge-Disjoint Trees)"
            read -p "Choice [1-3]: " size_choice
            case $size_choice in
                1) GRAPH_TYPE=1; GRAPH_LABEL="K4 Complete Graph" ;;
                2) GRAPH_TYPE=2; GRAPH_LABEL="Wheel Graph W5" ;;
                3) GRAPH_TYPE=3; GRAPH_LABEL="Resilient Network" ;;
            esac
            ;;
        3)
            echo -e "\n${YELLOW}Select Difficulty:${NC}"
            echo "1) Easy   (Random Legal Moves)"
            echo "2) Medium (Dijkstra / Network Volume Heuristic)"
            echo "3) Hard   (Lehman's Base Exchange Strategy)"
            read -p "Choice [1-3]: " diff_choice
            case $diff_choice in
                1) DIFFICULTY="Easy"; STRATEGY="Random" ;;
                2) DIFFICULTY="Medium"; STRATEGY="Network Volume" ;;
                3) DIFFICULTY="Hard"; STRATEGY="Lehman's Base Exchange" ;;
            esac
            ;;
        4)
            echo -e "\n${YELLOW}Select Your Role:${NC}"
            echo "1) Play as Short (Goal: Connect terminals)"
            echo "2) Play as Cut   (Goal: Sever all paths)"
            echo "3) Randomize Role"
            read -p "Choice [1-3]: " role_choice
            case $role_choice in
                1) PLAYER_ROLE="Short" ;;
                2) PLAYER_ROLE="Cut" ;;
                3) PLAYER_ROLE="Random" ;;
            esac
            ;;
        5)
            echo -e "\n${YELLOW}Select Turn Order:${NC}"
            echo "1) Human moves First"
            echo "2) Human moves Second"
            echo "3) Randomize Turn Order"
            read -p "Choice [1-3]: " turn_choice
            case $turn_choice in
                1) TURN_ORDER="First" ;;
                2) TURN_ORDER="Second" ;;
                3) TURN_ORDER="Random" ;;
            esac
            ;;
        6)
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
The Lisp component handles game flow, state managemant, the building of boards, and strategic AI using Minimax and Dijkstra algorithms.

```lisp
;;; shannon-engine.lisp
;;; run with: sbcl --script shannon-engine.lisp [GRAPH] [DIFF] [HUMAN-ROLE] [FIRST-PLAYER]

(setf *random-state* (make-random-state t)) ; Seed RNG

(defparameter *graph-type* 1)       ; 1=K4, 2=Wheel, 3=Resilient
(defparameter *difficulty-level* 3) ; 1=Easy, 2=Med, 3=Hard
(defparameter *human-role* 1)       ; 1 = Short, 2 = Cut
(defparameter *current-player* 1)   ; 1 = Short, 2 = Cut (Determines whose turn it is)

;; Graph Data Structures
(defparameter *nodes* nil)
(defparameter *edges* nil)
(defparameter *terminals* '(0 0)) 

;;; --- Graph Generation ---

(defun init-graph (type)
  (setf *nodes* nil)
  (setf *edges* nil)
  (case type
    (1 ;; Wheel Graph W5 (Easiest: 5 Vertices, 8 Edges)
     (setf *nodes* '((0 200 50 "s" t)
                     (1 50 200 "v1" nil)
                     (2 350 200 "v2" nil)
                     (3 200 200 "c" nil) ; center node
                     (4 200 350 "t" t)))
     (setf *terminals* '(0 4))
     (setf *edges* '((1 0 1 :free 0) (2 0 3 :free 0) (3 0 2 :free 0)
                     (4 1 3 :free 0) (5 2 3 :free 0)
                     (6 1 4 :free 0) (7 3 4 :free 0) (8 2 4 :free 0))))
    
    (2 ;; Resilient Network (Middle: 6 Vertices, 10 Edges)
     (setf *nodes* '((0 200 40 "s" t)
                     (1 100 140 "u" nil)
                     (2 300 140 "v" nil)
                     (3 100 260 "w" nil)
                     (4 300 260 "x" nil)
                     (5 200 360 "t" t)))
     (setf *terminals* '(0 5))
     (setf *edges* '((1 0 1 :free 0)   ; T1: s-u
                     (2 1 3 :free 0)   ; T1: u-w
                     (3 3 2 :free 0)   ; T1: w-v (crosses center)
                     (4 2 4 :free 0)   ; T1: v-x
                     (5 4 5 :free 0)   ; T1: x-t
                     (6 0 2 :free 0)   ; T2: s-v
                     (7 2 1 :free 0)   ; T2: v-u
                     (8 1 4 :free 0)   ; T2: u-x (crosses center)
                     (9 4 3 :free 0)   ; T2: x-w
                     (10 3 5 :free 0)))) ; T2: w-t

    (3 ;; Petersen Graph (Hardest: 10 Vertices, 15 Edges)
     (setf *nodes* '((0 200 40 "s" t)         ; outer top
                     (1 340 140 "v1" nil)     ; outer TR
                     (2 280 320 "v2" nil)     ; outer BR
                     (3 120 320 "v3" nil)     ; outer BL
                     (4 60 140 "v4" nil)      ; outer TL
                     (5 200 120 "v5" nil)     ; inner top
                     (6 260 170 "v6" nil)     ; inner TR
                     (7 230 250 "t" t)        ; inner BR (Terminal!)
                     (8 170 250 "v8" nil)     ; inner BL
                     (9 140 170 "v9" nil)))   ; inner TL
     (setf *terminals* '(0 7))
     (setf *edges* '((1 0 1 :free 0) (2 1 2 :free 0) (3 2 3 :free 0)
                     (4 3 4 :free 0) (5 4 0 :free 0) 
                     (6 0 5 :free 0) (7 1 6 :free 0) (8 2 7 :free 0)
                     (9 3 8 :free 0) (10 4 9 :free 0)
                     (11 5 7 :free 0) (12 7 9 :free 0) (13 9 6 :free 0)
                     (14 6 8 :free 0) (15 8 5 :free 0))))))

;;; --- Node & Edge Helpers ---

(defun get-node (id)
  (find id *nodes* :key #'first))

(defun get-edge (id)
  (find id *edges* :key #'first))

(defun update-edge-status (id new-status)
  (let ((edge (get-edge id)))
    (when edge
      (setf (nth 3 edge) new-status))))

(defun free-edges ()
  (remove-if-not (lambda (e) (eq (nth 3 e) :free)) *edges*))

;;; --- SVG Rendering ---

(defun draw-svg-board (filename &optional game-over-msg)
  (let* ((scale 1.75)
	 (width (* 400 scale))
         (height (* 400 scale))
         (temp-filename (concatenate 'string filename ".tmp"))
         (svg-data
          (with-output-to-string (stream)
            (format stream "<svg xmlns='http://www.w3.org/2000/svg' width='~A' height='~A'>~%" width height)
            (format stream "<style>text { font-family: sans-serif; font-size: 14px; text-anchor: middle; dominant-baseline: middle; font-weight: bold; }</style>~%")
            (format stream "<rect width='100%' height='100%' fill='#f0f0f5'/>~%")
            
            ;; 1. Draw Edges
            (dolist (edge *edges*)
              (let* ((id (nth 0 edge))
                     (u-node (get-node (nth 1 edge)))
                     (v-node (get-node (nth 2 edge)))
                     (status (nth 3 edge))
                     (curve (* (nth 4 edge) scale))
                     (x1 (* (nth 1 u-node) scale)) (y1 (* (nth 2 u-node) scale))
                     (x2 (* (nth 1 v-node) scale)) (y2 (* (nth 2 v-node) scale))
                     
                     ;; Calculate geometry for all edges
                     (mid-x (/ (+ x1 x2) 2.0))
                     (mid-y (/ (+ y1 y2) 2.0))
                     (dx (- x2 x1))
                     (dy (- y2 y1))
                     (dist (sqrt (+ (* dx dx) (* dy dy))))
                     (nx (if (= dist 0) 0.0 (/ (- dy) dist))) 
                     (ny (if (= dist 0) 0.0 (/ dx dist)))    
                     (cx (+ mid-x (* nx curve)))
                     (cy (+ mid-y (* ny curve))))
                
                (let ((color (case status
                               (:free "#a0a0a0")
                               (:short "#1a75ff")
                               (:cut "#ff4d4d")))
                      (stroke-w (case status
                                  (:free "4")
                                  (:short "8")
                                  (:cut "2")))
                      (dash (if (eq status :cut) "stroke-dasharray='5,5'" "")))
                  
                  (if (= curve 0)
                      (format stream "<line x1='~A' y1='~A' x2='~A' y2='~A' stroke='~A' stroke-width='~A' ~A />~%" 
                              x1 y1 x2 y2 color stroke-w dash)
                      (format stream "<path d='M ~A ~A Q ~A ~A ~A ~A' stroke='~A' stroke-width='~A' fill='none' ~A />~%"
                              x1 y1 cx cy x2 y2 color stroke-w dash))
                  
                  ;; Draw Edge ID Label ON the line, but at 35% of its length to prevent center-crossing overlaps
                  (let* ((lx (if (= curve 0) (+ x1 (* dx 0.25)) (+ mid-x (* nx curve 0.5))))
                         (ly (if (= curve 0) (+ y1 (* dy 0.25)) (+ mid-y (* ny curve 0.5)))))
                    (format stream "<circle cx='~A' cy='~A' r='10' fill='white' stroke='~A' stroke-width='1'/>~%" lx ly color)
                    (format stream "<text x='~A' y='~A' fill='black'>e~A</text>~%" lx (+ ly 1) id)))))

            ;; 2. Draw Nodes
            (dolist (node *nodes*)
              (let ((x (* (nth 1 node) scale))
                    (y (* (nth 2 node) scale))
                    (label (nth 3 node))
                    (is-term (nth 4 node)))
                (if is-term
                    (format stream "<circle cx='~A' cy='~A' r='18' fill='#262626'/>~%" x y)
                    (format stream "<circle cx='~A' cy='~A' r='14' fill='#d9d9d9' stroke='#262626' stroke-width='2'/>~%" x y))
                (format stream "<text x='~A' y='~A' fill='~A'>~A</text>~%" 
                        x (1+ y) (if is-term "white" "black") label)))

            ;; Game Over Overlay
            (when game-over-msg
              (let ((box-w 300) (box-h 60))
                (format stream "<rect x='~A' y='~A' width='~A' height='~A' fill='black' opacity='0.85' rx='8'/>~%" 
                        (- (/ width 2.0) (/ box-w 2.0)) (- (/ height 2.0) (/ box-h 2.0)) box-w box-h)
                (format stream "<text x='~A' y='~A' font-size='22' fill='white'>~A</text>~%" 
                        (/ width 2.0) (+ (/ height 2.0) 2) game-over-msg)))
            
            (format stream "</svg>~%"))))

    (with-open-file (out temp-filename :direction :output :if-exists :supersede :if-does-not-exist :create)
      (write-string svg-data out))
    (rename-file temp-filename filename)))

;;; --- Win Detection (BFS) ---

(defun get-neighbors (node-id valid-statuses)
  (let ((neighbors nil))
    (dolist (edge *edges*)
      (when (member (nth 3 edge) valid-statuses)
        (let ((u (nth 1 edge)) (v (nth 2 edge)))
          (cond ((= u node-id) (push v neighbors))
                ((= v node-id) (push u neighbors))))))
    neighbors))

(defun path-exists-p (valid-statuses)
  (let ((start (first *terminals*))
        (target (second *terminals*))
        (queue nil)
        (visited nil))
    (push start queue)
    (loop while queue do
      (let ((curr (pop queue)))
        (unless (member curr visited)
          (push curr visited)
          (when (= curr target)
            (return-from path-exists-p t))
          (let ((neighbors (get-neighbors curr valid-statuses)))
            (dolist (n neighbors)
              (push n queue))))))
    nil))

(defun check-win ()
  (cond
    ((path-exists-p '(:short)) 1)            
    ((not (path-exists-p '(:short :free))) 2) 
    (t nil)))

;;; --- AI Algorithms (Easy & Medium) ---

;;; --- AI Algorithms (Easy, Medium & Hard) ---

(defun simulate-and-check (edge-id test-player)
  "Temporarily applies a move to see if it immediately wins the game."
  (let ((original-status (nth 3 (get-edge edge-id)))
        (test-status (if (= test-player 1) :short :cut))
        (win-result nil))
    (update-edge-status edge-id test-status)
    (setf win-result (check-win))
    (update-edge-status edge-id original-status) ; backtrack
    (if (eq win-result test-player) t nil)))

(defun find-winning-move (player)
  "Returns the edge-id of a 1-move win if one exists, otherwise NIL."
  (dolist (edge (free-edges))
    (let ((edge-id (nth 0 edge)))
      (when (simulate-and-check edge-id player)
        (return-from find-winning-move edge-id))))
  nil)

(defun get-greedy-moves (player)
  "Returns a list of free edge-ids that touch a terminal or an already owned edge."
  (let ((owned-status (if (= player 1) :short :cut))
        (moves nil))
    (dolist (edge (free-edges))
      (let ((id (nth 0 edge))
            (u (nth 1 edge))
            (v (nth 2 edge)))
        (when (or (member u *terminals*)
                  (member v *terminals*)
                  (get-neighbors u (list owned-status))
                  (get-neighbors v (list owned-status)))
          (push id moves))))
    moves))

(defun ai-easy-move (player)
  "Easy AI: Pure greedy expansion. No threat detection."
  (let ((greedy (get-greedy-moves player))
        (available (free-edges)))
    (cond
      (greedy (nth (random (length greedy)) greedy))
      (available (nth 0 (nth (random (length available)) available)))
      (t nil))))

(defun ai-medium-move (player)
  "Medium AI: Win immediately, block opponent wins, or play greedy."
  (let ((my-win (find-winning-move player))
        (opp-win (find-winning-move (if (= player 1) 2 1))))
    (cond
      (my-win my-win)     
      (opp-win opp-win)   
      (t (ai-easy-move player)))))

;;; -- Hard AI Heuristics --

(defun evaluate-board ()
  "Evaluates the board from Short's perspective using Dijkstra.
   Short wants a LOW score. Cut wants a HIGH score."
  (let ((start (first *terminals*))
        (target (second *terminals*))
        (queue (list (first *terminals*)))
        (dist (make-hash-table)))
    
    (setf (gethash start dist) 0)
    
    (loop while queue do
      ;; Pop node with minimum distance
      (let ((curr nil) (min-d 9999))
        (dolist (node queue)
          (let ((d (gethash node dist 9999)))
            (when (< d min-d)
              (setf min-d d)
              (setf curr node))))
        (setf queue (remove curr queue :count 1))
        
        (let ((d (gethash curr dist)))
          (dolist (edge *edges*)
            (let ((u (nth 1 edge))
                  (v (nth 2 edge))
                  (status (nth 3 edge)))
              (when (or (= curr u) (= curr v))
                (let* ((neighbor (if (= curr u) v u))
                       ;; Short edges cost 0, Cut edges cost 999, Free cost 1
                       (cost (cond ((eq status :short) 0) 
                                   ((eq status :cut) 999) 
                                   (t 1)))
                       (new-d (+ d cost)))
                  (when (< cost 999)
                    (let ((old-d (gethash neighbor dist 9999)))
                      (when (< new-d old-d)
                        (setf (gethash neighbor dist) new-d)
                        (pushnew neighbor queue)))))))))))
    
    ;; Calculate final score: (Shortest path * 1000) + Total Network Volume
    (let ((target-dist (gethash target dist 9999))
          (volume 0))
      (maphash (lambda (k v) 
                 (declare (ignore k)) 
                 (when (< v 999) (incf volume v))) 
               dist)
      (+ (* target-dist 1000) volume))))

(defun ai-hard-move (player)
  "Hard AI: Minimax Depth 2 using Dijkstra Pathfinding."
  (let ((best-move nil)
        (best-score (if (= player 1) 9999999 -9999999))
        (available (free-edges)))
    
    ;; 1. Always take an immediate win or block an immediate loss first to save processing time
    (let ((my-win (find-winning-move player))
          (opp-win (find-winning-move (if (= player 1) 2 1))))
      (when my-win (return-from ai-hard-move my-win))
      (when opp-win (return-from ai-hard-move opp-win)))

    ;; 2. Minimax search
    (dolist (my-edge available)
      (let* ((my-id (nth 0 my-edge))
             ;; Worst case scenario caused by opponent's best response
             (worst-opp-score (if (= player 1) -9999999 9999999)))
        
        ;; Simulate AI move
        (update-edge-status my-id (if (= player 1) :short :cut))

        (let ((opp-available (free-edges)))
          (if (null opp-available)
              ;; Board full, just evaluate
              (setf worst-opp-score (evaluate-board))
              
              ;; Simulate all opponent responses
              (dolist (opp-edge opp-available)
                (let ((opp-id (nth 0 opp-edge)))
                  (update-edge-status opp-id (if (= player 1) :cut :short))
                  
                  (let ((score (evaluate-board)))
                    (if (= player 1)
                        ;; Opponent is Cut, they want to MAXIMIZE score
                        (when (> score worst-opp-score) (setf worst-opp-score score))
                        ;; Opponent is Short, they want to MINIMIZE score
                        (when (< score worst-opp-score) (setf worst-opp-score score))))
                  
                  ;; Backtrack opponent move
                  (update-edge-status opp-id :free)))))

        ;; Backtrack AI move
        (update-edge-status my-id :free)

        ;; Record the move that minimizes the opponent's maximum damage
        (if (= player 1)
            (when (< worst-opp-score best-score)
              (setf best-score worst-opp-score best-move my-id))
            (when (> worst-opp-score best-score)
              (setf best-score worst-opp-score best-move my-id)))))
    
    (or best-move (ai-medium-move player))))

(defun ai-move (player)
  "Routes the AI decision based on the selected difficulty level."
  (case *difficulty-level*
    (1 (ai-easy-move player))
    (2 (ai-medium-move player))
    (3 (ai-hard-move player))
    (otherwise (ai-easy-move player))))

;;; --- Game Loop (REPL) ---

(defun apply-move (edge-id player)
  (let ((new-status (if (= player 1) :short :cut)))
    (update-edge-status edge-id new-status))
  
  (let ((winner (check-win)))
    (if winner
        (let ((msg (if (= winner 1) "SHORT WINS! (Path Secured)" "CUT WINS! (Network Severed)")))
          (draw-svg-board "current_shannon_board.svg" msg)
          (format t "~%========================================~%")
          (format t "          ~A         ~%" msg)
          (format t "========================================~%")
          t) 
        (progn
          (draw-svg-board "current_shannon_board.svg")
          (setf *current-player* (if (= player 1) 2 1))
          nil))))

;;; --- Game Loop (REPL) ---

(defun game-loop ()
  (loop
    (if (= *current-player* *human-role*)
        ;; Human Turn
        (progn
          (format t "~%~A's turn! Enter edge ID to ~A (e.g., '1' for e1) > " 
                  (if (= *human-role* 1) "SHORT" "CUT")
                  (if (= *human-role* 1) "secure" "delete"))
          (force-output)
          (let ((input (read-line *standard-input* nil :eof)))
            (when (eq input :eof) (return))
            (let* ((trimmed (string-trim " eE" input))
                   (edge-id (parse-integer trimmed :junk-allowed t)))
              (if edge-id
                  (let ((edge (get-edge edge-id)))
                    (if (and edge (eq (nth 3 edge) :free))
                        (when (apply-move edge-id *current-player*) (return))
                        (format t "Invalid move! Edge e~A is already claimed or doesn't exist.~%" edge-id)))
                  (format t "Invalid input! Please enter a number (e.g., 1).~%")))))
        
        ;; AI Turn
        (progn
          (format t "~%AI (~A) is thinking...~%" (if (= *current-player* 1) "SHORT" "CUT"))
          (sleep 1.0)
          (let ((move (ai-move *current-player*)))
            (if move
                (progn
                  (format t "AI selects edge e~A.~%" move)
                  (when (apply-move move *current-player*) (return)))
                (progn
                  (format t "AI has no valid moves!~%")
                  (return))))))))

;;; --- Main Execution ---
(let ((args (cdr sb-ext:*posix-argv*)))
  (when (>= (length args) 4)
    (setf *graph-type* (parse-integer (first args)))
    (setf *difficulty-level* (parse-integer (second args)))
    (setf *human-role* (parse-integer (third args)))
    (setf *current-player* (parse-integer (fourth args)))))

(init-graph *graph-type*)
(draw-svg-board "current_shannon_board.svg")
(game-loop)
```

**References:**
* Berlekamp, E. R., Conway, J. H., and Guy, R. K. (1982). *Winning Ways for your Mathematical Plays*, volumes 1 and 2. Academic Press, London.
* Lehman, A. (1964). A Solution of the Shannon Switching Game. *Journal of the Society for Industrial and Applied Mathematics*, 12(4):687–725.
* Tutte, W. T. (1961). On the problem of decomposing a graph into $n$ connected factors. *Journal of the London Mathematical Society*, 1(1):221–230.
* Nash-Williams, C. S. J. A. (1961). Edge-disjoint spanning trees of finite graphs. *Journal of the London Mathematical Society*, 1(1):445–450.
* Minty, G. J. (1966). On the axiomatic foundations of the theories of directed linear graphs, electrical networks and network-programming. *Journal of Mathematics and Mechanics*, 15:485–520.
* Oxley, J. (2011). *Matroid Theory*. Oxford University Press, 2nd edition.