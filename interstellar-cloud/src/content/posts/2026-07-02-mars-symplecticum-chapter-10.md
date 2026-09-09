---
title: "HEX: Scourge of Copenhagen"
pubDatetime: 2026-08-22T00:00:00Z
description: "An exploration of the game of Hex, topological proofs, virtual connections, and a complete implementation in bash and lisp."
author: "Jerod Michel, Gao Yucheng"
tags: ["bash", "lisp", "combinatorial game theory", "command line", "Hex", "perfect information", "math"]
---

<blockquote class="text-right ml-auto max-w-2xl italic mb-8 !border-none !pl-0 before:content-none after:content-none [quotes:none]">
  <p>"He who defends everything, defends nothing."</p>
  <p class="font-bold mt-2">— Frederick the Great (Prussia)</p>
</blockquote>

## Description

Hex is not a game of maneuvering, grand feints, or tactical captures. It is a zero-sum race for connection, where players are either building walls, or building bridges. The hexagonal grid's inherent structure makes a draw impossible. One of the players is guaranteed to connect their sides, and their opponent's to be permanently severed. 

## History

The game was born twice, each time out of sheer mathematical necessity, and each time in the shadow of a world picking itself apart. 

**PIET HEIN'S POLYGON (1942):** In 1942, the Danish polymath Piet Hein introduced it to readers of a Copenhagen newspaper as *Polygon*—a stark, logical puzzle handed to a populace living under German occupation.

**JOHN NASH'S REINVENTION (1948):** Six years later, and an ocean away, John Nash reinvented it at Princeton without any knowledge of Hein's version. Nash stripped it down to its game-theoretic bones, recognizing it as a finite, perfect-information contest, and produced the infamous *strategy stealing* proof—a mathematical ghost argument that shows the first player must have a winning strategy. Nash's proof shows that the kill shot exists, but withholds the gun.

**PARKER BROTHERS (1952):** By 1952, Parker Brothers had boxed it up as *Hex*—much like how David Gale's network game was packaged as *Bridg-It*.

## Rules and Gameplay

Hex is tauntingly simple to learn and computationally agonizing to master. Two players, Red and Blue, face off on a rhombus-shaped grid of regular hexagons—an $11 \times 11$ board being the standard arena, though any symmetric field serves equally well. Two opposing edges belong to Red, and the remaining two belong to Blue. The board begins as empty territory.

**Legal Moves.** Players alternate placing single stones of their color onto any unoccupied cell. This is the entirety of the rules—once a stone is placed, it is permanent. There are no captures, no retreats, no shifting of pieces. Every move irreversibly alters the position. Passing is forbidden—players must act.

**The Pie Rule.** As Nash's proof confirmed that the first player holds a decisive theoretical advantage, competitive play employs the *pie rule* to restore balance: after the opening stone is placed, the second player faces a terrible binary choice of whether to play on as usual, or *swap*—treating that first stone as their own and then reversing the roles for the remainder of the game. This transforms the first move from a declaration of intent to a poisoned offering, where placing too strong a stone might be used against the one who placed it.

**Termination and Victory.** Play continues until one player forms an unbroken chain connecting their two sides. As the Hex theorem guarantees that a fully populated board must contain exactly one such path, there are no stalemates, nor draws.

## Mathematics of Hex

### Basic Definitions and the Hex Theorem

We first strip away the artifice of movement and capture.

#### Grid Topology

We define the Hex board, $H_n$, as a finite graph consisting of a set of vertices $V$ (the hexagonal cells) arranged in an $n \times n$ rhombus. 

Unlike the binary wires of Shannon Switching, a vertex in Hex is highly connected. Every internal cell $v \in V$ is adjacent to exactly six neighboring cells. We denote the four boundaries of this rhombus as $N, S, E,$ and $W$. Player One (Red) is assigned the boundaries $N$ and $S$. Player Two (Blue) is assigned $E$ and $W$. 

The objective is primitive: Player One seeks to form a connected subgraph containing at least one vertex in $N$ and at least one vertex in $S$. Player Two seeks the same, but for $E$ and $W$.

![Figure 1: Foundational $5 \times 5$ Hex board. Red seeks to connect North to South; Blue seeks to connect West to East.](/hex5x5.png)

#### The Hex Theorem

A player either survives, or is severed. This is formalized in the following.

<div class="theorem">

**Theorem (Hex Theorem).**

If each cell of an $n \times n$ Hex board is assigned to either Player One or Player Two, then there exists either a connected path of Player One's cells joining $N$ to $S$, or a connected path of Player Two's cells joining $E$ to $W$, but never both.

</div>

<div class="proof">

**Proof (Elementary Proof - Crossing Argument).**

The tactical intuition behind this theorem is obvious to anyone who has ever built a fortification. To block your opponent from connecting East to West, you must build a continuous, unbroken barrier from North to South.

On a hexagonal grid, it is geometrically impossible for a North-South path to cross an East-West path without sharing exactly one cell. Since a given cell can belong to only one player, the paths cannot safely cross, or, intersect. If the board is completely filled and Player One has failed to connect $N$ to $S$, then it is strictly due to Player Two having constructed a thoroughly blocking wall. As the adjacency of the hexagonal grid is 6-way, this blocking wall is, by definition, a continuous path connecting $E$ to $W$.
<div class="text-right">&#9633;</div>

</div>

#### Topological Equivalence: Sperner's Lemma

While the elementary crossing argument shows the Hex Theorem tactically, Gale, in 1979, connected Hex to the discrete combinatorial version of the Brouwer Fixed-Point Theorem called *Sperner's Lemma*.

<div class="theorem">

**Theorem (Sperner's Lemma (2D)).**

Suppose a large triangle $T$ with vertices $V_1, V_2, V_3$ is partitioned into smaller sub-triangles. The vertices of this triangulation are colored with three colors (Red, Blue, Green) such that:
1. $V_1, V_2, V_3$ are colored red, blue, and green, respectively,
2. any vertex on an edge of $T$ is colored using only the two colors of the endpoints of that edge, and
3. internal vertices may be colored with any of the three colors.

Then there exists at least one sub-triangle whose vertices are each of a distinct color.

</div>

<div class="proof">

**Proof.**

We prove this using a graph-theoretic parity argument. We define a "door" as any line segment in the triangulation whose two endpoints are colored Red and Blue.
    
First, we examine the outer boundary of the large triangle $T$. The edge $(V_1, V_2)$ is subsequently divided into smaller segments. As the sequence of colors along this edge starts at red and ends at blue, the number of instances of the pair (red, blue) in this sequence must be odd. Therefore, the outer boundary of $T$ contains an odd number of red-blue *doors*. The other two outer edges of $T$ contain zero red-blue doors.
    
Next, we examine the internal sub-triangles, or, *rooms*. A sub-triangle can have: exactly 1 red-blue door (if its vertices are red, blue, green)—this is our target *rainbow* triangle, exactly 2 red-blue doors (if its vertices are red, blue, blue or red, red, blue), or, exactly 0 red-blue doors (if it lacks either red or blue entirely).
 
We now construct a path by entering the large triangle $T$ through one of the red-blue doors on the outer boundary. Once inside a room, if it has two doors, we must immediately exit through the other door, and enter an adjacent room.
    
Since the triangulation is finite, the path cannot go on forever, nor can it cross its own path, or loop back onto itself as a two-door room has only one entry and one exit. Therefore, the path must eventually terminate. There are only two ways a path can terminate: it can exit the large triangle $T$ via another red-blue door on the outer boundary, or it can enter a room having exactly one red-blue door (a rainbow triangle) and stop.
   
As there are an odd number of red-blue doors on the outer boundary, it is impossible for every path to pair an entrance door with an exit door (which would require an even total). This parity mismatch guarantees that at least one path cannot exit the boundary, and must therefore terminate inside of a rainbow triangle.
<div class="text-right">&#9633;</div>

</div>

**Gale's Hex Reduction:** Gale demonstrated that the hexagonal grid of a Hex board is the geometric dual of a triangulated lattice. By mapping the empty, Red, and Blue cells of a completed Hex game to the three colors of a Sperner triangulation, he showed that if a game of Hex could theoretically end in a draw (with neither North-South or East-West being connected), it would map to a valid Sperner coloring completely lacking a rainbow triangle. Since Sperner's Lemma forbids this, a draw in Hex must be impossible.

### The Strategy-Stealing Argument

In 1948, John Nash demonstrated that, on a standard symmetric board, Hex favors the first player from the initial move. This conclusion relies on the impossibility of a draw established in Theorem \ref{hex}.

Nash's methodology for proving this was the original *strategy-stealing argument*—the exact mathematical blueprint that David Gale would borrow a decade later to prove the first-player advantage in his own connection game.

<div class="theorem">

**Theorem (Nash, 1948).**

When Hex is played on an $n \times n$ board, the first player has a winning strategy.

</div>

<div class="proof">

**Proof.**

The proof is structurally identical to that of Gale's Strategy-Stealing Theorem (Chapter 8, Theorem 4.2). Since Hex is a finite, deterministic game of perfect information with no chance as well as, when played on an $n \times n$ board, a symmetric, strictly monotonic connection game, its game tree must terminate in evaluated states. By Theorem \ref{hex}, a draw is strictly impossible, and so exactly one player must possess a forced win.

Assume for contradiction that the second player has a winning strategy, $\mathcal{S}$. The first player places an arbitrary first stone, and then conceptually adopts $\mathcal{S}$ for all subsequent turns. Since Hex, like Gale, is strictly monotonic—meaning an extra stone on the board can only aid, never hinder, a player's connection—the first player's arbitrary initial move acts as a harmless, potentially beneficial extra piece. 

Should $\mathcal{S}$ ever instruct the first player to place a stone where they have already placed one, they simply make a new arbitrary move. Consequently, the first player is guaranteed to win using $\mathcal{S}$. This contradicts our assumption that $\mathcal{S}$ guarantees a win for the second player. Thus, the first player must possess the winning strategy.
<div class="text-right">&#9633;</div>

</div>

<div class="remark">

**Remark.**

As in Gale, Nash's argument is a pure existence proof. It guarantees a winning strategy for the first player exists, but it remains non-constructive.

</div>

### Positional Game Theory and Virtual Connections

Hex requires a distinct analytical framework from both Gale and Shannon Switching. While Shannon Switching is an asymmetric (Short versus Cut) contest, both Gale and Hex are symmetric (Short versus Short) connection games. The critical divergence lies in the topology of the board. Gale is played on the edges of interleaved grids, a structure that allows for exact pairing strategies. Hex, conversely, is played on the vertices of a highly connected lattice. Since a single stone in Hex permanently occupies a vertex and simultaneously blocks up to six adjacent pathways, the spatial entanglement is vastly more complex. Lacking a computationally tractable algebraic structure or a simple pairing strategy, tactical mastery in Hex relies entirely on securing spatial advantage via overlapping threats.

#### Virtual Connections

The core unit of Hex strategy is not the directly adjacent stone, but the virtual connection. A *virtual connection* exists between two elements (stones or borders) if there is an explicit, guaranteed strategy to connect them, regardless of the opponent's responses.

**Atomic Connection:** The simplest and most fundamental virtual connection, called the *bridge*, is two stones separated by a single empty row and offset by one column share exactly two common adjacent empty cells. 

![Figure 2: The Bridge. Two red stones share exactly two common empty adjacent cells (A and B). If Blue occupies A, Red immediately occupies B (and vice versa), making the connection virtual.](/hexbridge.png)

Since the connection is guaranteed, as an opponent would need to place two stones in one turn to block it, it is treated as a solid, unbreakable connection.

**Edge Templates: Anchoring to the Boundary:** A stone placed directly adjacent to the edge is trivially connected. However, securing a connection to the boundary from deeper within the board requires *edge templates*—pre-calculated patterns of empty cells guaranteeing a path to the border.

![Figure 3: Third-Row Edge Template. Left: Red establishes an anchor stone two rows away from the border, maintaining overlapping control over the five empty cells beneath. Right: Blue attempts to block the path by intruding at cell A. Red immediately responds by securing cell B, as cell B forms a bridge to the border.](/hexanchor.png)

The most common of these is the *third-row template*, which is a stone placed on the third row from a player's own border, as it commands a specific overlapping set of empty cells between itself and the edge. If the area remains undisturbed, the stone is virtually connected to the edge. If the opponent intrudes, the overlapping bridge mechanics guarantee the defending player can drop a stone to re-secure the path. Recognizing and memorizing these templates is equivalent to studying opening theory.

**Ladders and Escapes:** When a player attempts to push a connection through an opponent's blocking wall, a specific sequence often emerges. A *ladder* is a forced sequence of moves where one player marches a line of stones parallel to an edge or an opposing wall, and the opponent is forced continually to lay blocking stones ahead of them.

A ladder is like a tactical knife-fight. The attacker (the player being blocked) is looking for a *ladder escape*—a friendly stone or template placed further down the board that the trajectory will eventually meet. If the ladder connects to the escape piece, then attacker has breached the wall. If the ladder runs into the edge of the board or an enemy template, the attack fails. Calculating ladder trajectories and planting escape routes constitute the primary mid-game mechanics.

### The Dominated Corner Theorem

The tools we have established—specifically the graph adjacency and strict monotonicity—allow us to show a tactical truth concerning the Hex board—that the acute corners of the rhombus are dead space.

On a standard Hex board, the four corners are not equal topologically. The two obtuse corners touch three adjacent cells, while the two acute corners touch exactly two adjacent cells.

<div class="theorem">

**Theorem (The Dead Cell).**

Playing a stone in an acute corner of an $n \times n$ Hex board ($n \ge 2$) is a strictly *dominated strategy*. That is, there exists no game state where playing in the acute corner is superior to playing in one of its adjacent cells.

</div>

<div class="proof">

**Proof.**

Let $c$ represent the cell at an acute corner. Due to the lattice being hexagonal, $c$ has exactly two neighboring cells, which we denote $x$ and $y$. Furthermore, the geometry of the grid guarantees that $x$ and $y$ are also adjacent to each other, forming the triangle $\triangle cxy$.

Suppose a player places a stone at $c$. For this stone to form part of a winning connection, the path must enter $c$ from one neighbor and exit via the other. Therefore, a path utilizing $c$ strictly requires that the player also control both $x$ and $y$.

Now suppose the player instead places their stone at $x$. Since $x$ and $y$ are mutually adjacent, controlling $x$ provides direct access to $y$ without needing to route through $c$. Also, while $c$ only borders $x$ and $y$, the internal cell $x$ borders up to six cells, expanding the player's potential pathways outward into the board. 

As Hex is a strictly monotonic connection game, abandoning $c$ to claim the larger neighborhood of $x$ cannot negatively impact the player's ability to connect, and any winning path that could have routed through $c$ could simply route directly from $x$ to $y$. Therefore, placing a stone at $c$ is strictly dominated by placing at $x$ (or $y$). 
<div class="text-right">&#9633;</div>

</div>

### Complexity

The intuition that Hex's overlapping geometry makes it exceptionally difficult to calculate was formally crystallized in 1981 by Stefan Reisch. Reisch showed that the problem of determining the winning player from an arbitrary generalized Hex position on an $n \times n$ board is $PSPACE$-complete.

In complexity theory, landing in the $PSPACE$-complete weight class means hitting a computational wall, and places Hex far beyond the polynomial-time reach of Gale or Shannon Switching. For the $11 \times 11$ board, the state-space complexity is roughly $10^{56}$. There is no shortcut, no algebraic invariant such as the nim-sum, nor any perfect pairing algorithm that can collapse the game tree.

In Gale and Shannon Switching, exact mathematical pairing strategies exist, even if we bypassed them to deploy generalized AI engines. In Hex, those exact algebraic shortcuts do not exist at all, nor can we command the computer to calculate a perfect pairing. Instead, the generalized search architecture we have developed throughout this text becomes a necessity. To navigate the combinatorial explosion, our Lisp engine must rely heavily on pathfinding algorithms such as Dijkstra to evaluate the strength of virtual connections, and Minimax to search the tangled game tree.

## Example of Gameplay

Having already formally defined virtual connections, bridges, and edge templates, we can now observe how a skilled player weaves them together. Humans do not calculate global shortest paths; instead, they recognize and combine these interlocking local patterns. If a player can chain enough overlapping templates together to span between their target borders, the game is decided, even if the physical path of stones is sparse.

### Forcing the Global Connection

Figure 4 illustrates a critical mid-game position on a $5 \times 5$ board. Red's goal is to connect the North border (row 1) to the South border (row 5). Red already has a stone established at **B2**. On this turn, Red places a single stone at **C3**. 

To an untrained eye, the board is mostly empty, and the stones appear disconnected; however, Red has already won. By placing the stone at **C3**, Red has simultaneously anchored three distinct, non-overlapping virtual connections:

* **The North Fork (Labeled N):** The stone at **(2,4)** sits exactly one row from the North border. It is adjacent to two empty border cells: **(1,5)** and **(2,5)**. This trivial fork guarantees connection to the North.
* **The Bridge (Labeled *):** The new stone at **(1,3)** forms a classic bridge with **(2,4)**, utilizing the shared empty cells **(1,4)** and **(2,3)**. 
* **The Edge Template (Labeled S):** **(1,3)** sits on the third row, establishing an Edge Template III with the South border through the five empty cells **(1,2), (2,2), (1,1), (2,1),** and **(3,1)**. 

Since the empty cells required for these three templates are mutually exclusive, Blue cannot disrupt more than one connection per turn. Red's global path from North to South is already secure, and the game is over.

![Figure 4: Red plays (1,3), anchoring three unblockable, non-overlapping virtual connections (labeled N, *, and S) that guarantee a path from North to South.](/hexplay.png)

## Hex in Command Line (with Lisp for game engines)

Instead of an explicit, free-form list of edges, our engine maintains a 1D array of vertices (cells), mapped mathematically to a 2D pointy-topped Cartesian grid. Connectivity is strictly defined by a 6-way adjacency list calculated dynamically upon board initialization.

### Algorithmic Adaptation for Hex

While we continue to rely on the algorithms introduced in our Gale chapter, the highly interconnected nature of Hex necessitates critical modifications to how these algorithms evaluate the game state.

**Bridge Paradox and Virtual Connection:** When Dijkstra's algorithm evaluates a standard Hex board, it calculates the shortest physical path from border to border. However, this pure graph-traversal causes the AI to suffer from "parallel path apathy." To a human, a bridge is an unblockable virtual connection. To a standard Dijkstra search, it is merely two parallel gaps. If the algorithm simulates an opponent blocking one gap, it seamlessly routes through the other, sees no mathematical change in the absolute path distance, and concludes that blocking the bridge is a waste of a turn.

To remedy this, our engine introduces a virtual connection pre-processor. Before Dijkstra traverses the board, this pre-processor scans the entire lattice for established bridges. If found, it wires the two stones together with a virtual edge at cost $0$. If the opponent intrudes into the bridge, the $0$-cost edge is revoked, the shortest path distance spikes, and the AI instantly recognizes the mathematical necessity of securing the connection.

**Dynamic Alpha-Beta Pruning:** Hex possesses an overwhelming branching factor. A standard, flat Minimax search quickly becomes computationally intractable. To survive this, our hard-level AI implements recursive alpha-beta pruning to sever all inferior futures before calculated.

To maximize the efficiency of these pruning cutoffs, we employ heuristic move ordering. The search tree evaluates central board positions first. By establishing a strong evaluation score early, the algorithm can instantly prune thousands of useless perimeter branches. Since this optimization is aggressive, the engine dynamically scales its search horizon: looking $3$ plies deep on $5 \times 5$ and $7 \times 7$ boards, and pulling back to $2$ plies for the computationally heavy $11 \times 11$ board.

### Architectural Overview

Our Hex implementation perfectly mirrors the theoretical progression of combinatorial difficulty, utilizing (as in previous chapters) a standalone Common Lisp engine directed by a Bash orchestrator.

**Common Lisp (SBCL):** The core engine dictates the mathematical reality of the game, handling all heavy computation:
* Generating the Cartesian coordinates and 6-way adjacency lists for the hexagonal tessellation.
* Executing breadth-first search (BFS) traversals from edge to edge to detect definitive win conditions.
* Scaling AI difficulty purely through computational depth: easy-level relies entirely on local tactical heuristics (templates and bridge building), medium-level utilizes a depth-1 global Dijkstra search, and hard-level executes the full alpha-beta Minimax search.
* Rendering the board directly to SVG format, calculating proper Cartesian offsets for drawing precise colored borders, and dynamic stone placements.

## Game Orchestration (Bash)

As with previous engines, the Bash script acts as the bare-metal terminal director. It captures the user's parameters of engagement (board size, AI difficulty, and turn order) and pipes them directly into the Lisp process as POSIX arguments. It manages an external image viewer (`eog`) as a background process to seamlessly live-update the SVG graphics as the Lisp engine mutates the board state, gracefully catching the exit signal upon a win condition to return the user to the main menu.

```bash
#!/bin/bash
cd "$(dirname "$0")" || exit 1

# ANSI Color Codes
BLUE='\033[1;34m'
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
NC='\033[0m' # no color

# initial state variables
BOARD_SIZE=5 
BOARD_LABEL="5x5 Board"
DIFFICULTY="Hard"
STRATEGY="Minimax + Virtual Connections"
PLAYER_ROLE="Red"     # options: red, blue, random
TURN_ORDER="First"    # options: first, second, random

# clear screen function
clear_screen() {
    printf "\033c"
}

# print header
print_header() {
    echo -e "${CYAN}========================================s${NC}"
    echo -e "${CYAN}                  H E X${NC}"
    echo -e "${CYAN}=========================================${NC}"
    echo -e "Board Size: ${YELLOW}${BOARD_LABEL}${NC} | Difficulty: ${YELLOW}${DIFFICULTY}${NC} (${STRATEGY})"
    echo -e "Human Plays: ${YELLOW}${PLAYER_ROLE}${NC} \vert{} Turn:${YELLOW}${TURN_ORDER}${NC}"
    echo -e "${CYAN}-----------------------------------------${NC}"
}

# launch game
start_game() {
    clear_screen
    echo -e "${GREEN}Initializing Lisp Engine...${NC}"
    echo -e "Starting on ${BOARD_LABEL} using${STRATEGY}."
    echo -e "Watch the eog window for the board state!\n"
    
    # touch SVG file so eog can open immediately
    rm -f current_hex_board.svg
    touch current_hex_board.svg
    
    # launch eog in background. (auto-reloads when file changes)
    eog current_hex_board.svg > eog_error.log 2>&1 &
    EOG_PID=$!

    # 1. translate ACTUAL_ROLE string into numeric human player ID (1=red, 2=blue)
    HUMAN_PLAYER=1
    if [ "$ACTUAL_ROLE" == "Blue" ]; then
        HUMAN_PLAYER=2
    fi

    # 2. translate ACTUAL_TURN string to determine which ID starts
    START_PLAYER=1
    if [ "$ACTUAL_TURN" == "First" ]; then
        START_PLAYER=$HUMAN_PLAYER
    else
        # if Human is second, start player is opponent
        if [ "$HUMAN_PLAYER" -eq 1 ]; then
            START_PLAYER=2
        else
            START_PLAYER=1
        fi
    fi

    # 3. translate DIFFICULTY string to numeric ID
    DIFF_NUM=3
    if [ "$DIFFICULTY" == "Easy" ]; then DIFF_NUM=1; fi
    if [ "$DIFFICULTY" == "Medium" ]; then DIFF_NUM=2; fi

    # display instructions based on role
    if [ "$ACTUAL_ROLE" == "Red" ]; then
        echo -e "${YELLOW}You are RED. Your goal is to CONNECT NORTH to SOUTH.${NC}"
    else
        echo -e "${YELLOW}You are BLUE. Your goal is to CONNECT WEST to EAST.${NC}"
    fi
    echo -e "${YELLOW}Enter your moves by specifying coordinates (e.g., A1, B3).${NC}"
    echo -e "${YELLOW}Press Ctrl+D if you wish to exit early.${NC}\n"
    
    # pass ALL 4 arguments to Lisp engine
    sbcl --script hex-engine.lisp $BOARD_SIZE$DIFF_NUM $HUMAN_PLAYER$START_PLAYER 2> engine_error.log
    
    echo -e "\n${GREEN}Game Over!${NC}"
    read -p "Press Enter to return to the main menu..."

    kill $EOG_PID 2>/dev/null
}

# main menu loop
while true; do
    clear_screen
    print_header
    echo "1) Start Game"
    echo "2) Set Board Size"
    echo "3) Set Difficulty"
    echo "4) Set Player Role (Red / Blue)"
    echo "5) Set Turn Order (First / Second)"
    echo "6) Exit"
    echo -e "${CYAN}-----------------------------------------${NC}"
    read -p "Select an option [1-6]: " choice

    case $choice in
        1)
            # handle random coin flips just before start
            ACTUAL_ROLE=$PLAYER_ROLE
            if [ "$ACTUAL_ROLE" == "Random" ]; then
                if [ $((RANDOM % 2)) -eq 0 ]; then ACTUAL_ROLE="Red"; else ACTUAL_ROLE="Blue"; fi
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
            echo -e "\n${YELLOW}Select Board Size:${NC}"
            echo "1) 5x5   (Fast Match)"
            echo "2) 7x7   (Standard Tactical)"
            echo "3) 11x11 (Full Game - Computationally Heavy)"
            read -p "Choice [1-3]: " size_choice
            case $size_choice in
                1) BOARD_SIZE=5; BOARD_LABEL="5x5 Board" ;;
                2) BOARD_SIZE=7; BOARD_LABEL="7x7 Board" ;;
                3) BOARD_SIZE=11; BOARD_LABEL="11x11 Board" ;;
            esac
            ;;
        3)
            echo -e "\n${YELLOW}Select Difficulty:${NC}"
            echo "1) Easy   (Random Legal Moves)"
            echo "2) Medium (Dijkstra Shortest Path Heuristic)"
            echo "3) Hard   (Minimax + Virtual Connections)"
            read -p "Choice [1-3]: " diff_choice
            case $diff_choice in
                1) DIFFICULTY="Easy"; STRATEGY="Random" ;;
                2) DIFFICULTY="Medium"; STRATEGY="Dijkstra Path Heuristic" ;;
                3) DIFFICULTY="Hard"; STRATEGY="Minimax + Virtual Connections" ;;
            esac
            ;;
        4)
            echo -e "\n${YELLOW}Select Your Role:${NC}"
            echo "1) Play as Red  (Goal: Connect North to South)"
            echo "2) Play as Blue (Goal: Connect West to East)"
            echo "3) Randomize Role"
            read -p "Choice [1-3]: " role_choice
            case $role_choice in
                1) PLAYER_ROLE="Red" ;;
                2) PLAYER_ROLE="Blue" ;;
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

## AI Engine (Common Lisp)

The Lisp component handles game flow, state management, the building of boards, and strategic AI using Minimax and Dijkstra algorithms.

```lisp
;;; hex-engine.lisp
;;; run with: sbcl --script hex-engine.lisp [BOARD-SIZE] [DIFF] [HUMAN-ROLE] [FIRST-PLAYER]

(setf *random-state* (make-random-state t)) ; seed rng

(defparameter *board-size* 5)       ; Default 5x5
(defparameter *difficulty-level* 3) ; 1=Easy, 2=Med, 3=Hard
(defparameter *human-role* 1)       ; 1 = Red, 2 = Blue
(defparameter *current-player* 1)   ; 1 = Red, 2 = Blue (whose turn it is)

;; graph data structures (vertex-claiming)
(defparameter *cells* nil)          ; holds cell data: (id row col label cx cy owner)
(defparameter *adj* (make-hash-table)) ; map: id -> list of neighbor ids

;;; --- Board Generation ---

(defun get-hex-centers (size radius)
  "Calculate exact cartesian centers of hex rhombus"
  (let ((centers nil)
        (offset-x (* radius 2))
        (offset-y (* radius 2)))
    (dotimes (row size)
      (dotimes (col size)
        (let* ((cx (+ offset-x (* col 1.732 radius) (* row 1.732 0.5 radius)))
               (cy (+ offset-y (* row 1.5 radius)))
               (id (+ (* row size) col))
               ;; label generation: col=0 -> A, row=0 -> 1 (e.g., A1, B3)
               (label (format nil "~A~A" (code-char (+ 65 col)) (1+ row))))
          (push (list id row col label cx cy :free) centers))))
    (reverse centers)))

(defun get-hex-neighbors (id size)
  "Calculate 6-way adjacency for cell in Hex lattice"
  (let* ((row (floor id size))
         (col (mod id size))
         (neighbors nil)
         (directions '((-1  0)  ; top left
                       (-1  1)  ; top right
                       ( 0 -1)  ; left
                       ( 0  1)  ; right
                       ( 1 -1)  ; bottom left
                       ( 1  0)))); bottom right
    (dolist (dir directions)
      (let ((nr (+ row (first dir)))
            (nc (+ col (second dir))))
        (when (and (>= nr 0) (< nr size) (>= nc 0) (< nc size))
          (push (+ (* nr size) nc) neighbors))))
    neighbors))

(defun init-board (size)
  "Initialize Hex board vertices and adjacency list"
  (setf *board-size* size)
  (clrhash *adj*)
  
  ;; dynamically scale radius to fit 11x11 on screen
  (let ((radius (if (>= size 11) 18 28)))
    (setf *cells* (get-hex-centers size radius)))
    
  (dotimes (id (* size size))
    (setf (gethash id *adj*) (get-hex-neighbors id size))))

;;; --- Node Helpers ---

(defun get-cell (id)
  (find id *cells* :key #'first))

(defun get-cell-by-label (label)
  (find (string-upcase label) *cells* :key #'fourth :test #'string=))

(defun update-cell-status (id new-status)
  (let ((cell (get-cell id)))
    (when cell
      (setf (nth 6 cell) new-status))))

(defun free-cells ()
  (remove-if-not (lambda (c) (eq (nth 6 c) :free)) *cells*))

;;; --- SVG Rendering ---

(defun draw-svg-board (filename &optional game-over-msg)
  "Renders board as SVG, applying red/blue borders and filled stones"
  (let* ((radius (if (>= *board-size* 11) 18 28))
         ;; calc board bounding box
         (width (+ 200 (* *board-size* 1.732 radius 1.5)))
         (height (+ 150 (* *board-size* 1.5 radius)))
         (temp-filename (concatenate 'string filename ".tmp"))
         (svg-data
          (with-output-to-string (stream)
            (format stream "<svg xmlns='[http://www.w3.org/2000/svg](http://www.w3.org/2000/svg)' width='~A' height='~A'>~%" width height)
            (format stream "<style>text { font-family: monospace; font-size: ~Apx; text-anchor: middle; dominant-baseline: middle; font-weight: bold; }</style>~%" (if (>= *board-size* 11) 10 14))
            (format stream "<rect width='100%' height='100%' fill='#1a1a1a'/>~%") ; dark background
            
            ;; 1. draw hexagons
            (dolist (cell *cells*)
              (let* ((id (nth 0 cell))
                     (row (nth 1 cell))
                     (col (nth 2 cell))
                     (cx (nth 4 cell))
                     (cy (nth 5 cell))
                     (status (nth 6 cell))
                     (fill-color (case status
                                   (:free "#e6e6e6")
                                   (:red "#ff4d4d")
                                   (:blue "#4d79ff")))
                     (text-color (if (eq status :free) "#808080" "#ffffff"))
                     
                     ;; explicitly define 6 pointy-topped corners for precise border tracing
                     (p-br (format nil "~A,~A" (+ cx (* radius 0.866)) (+ cy (* radius 0.5))))
                     (p-b  (format nil "~A,~A" cx (+ cy radius)))
                     (p-bl (format nil "~A,~A" (- cx (* radius 0.866)) (+ cy (* radius 0.5))))
                     (p-tl (format nil "~A,~A" (- cx (* radius 0.866)) (- cy (* radius 0.5))))
                     (p-t  (format nil "~A,~A" cx (- cy radius)))
                     (p-tr (format nil "~A,~A" (+ cx (* radius 0.866)) (- cy (* radius 0.5))))
                     
                     (points (format nil "~A ~A ~A ~A ~A ~A" p-br p-b p-bl p-tl p-t p-tr)))
                
                ;; draw primary cell polygon
                (format stream "<polygon points='~A' fill='~A' stroke='#1a1a1a' stroke-width='3'/>~%" points fill-color)
                
                ;; draw thick colored borders for perimeter cells
                ;; west border (blue) - shifted CCW left and bottom-left faces
                (when (= col 0) 
                  (format stream "<polyline points='~A ~A ~A' fill='none' stroke='#4d79ff' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>~%" p-tl p-bl p-b))
                
                ;; east border (blue) - shifted CCW right and top-right faces
                (when (= col (1- *board-size*)) 
                  (format stream "<polyline points='~A ~A ~A' fill='none' stroke='#4d79ff' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>~%" p-br p-tr p-t))
                
                ;; north border (red) - top-left and top-right faces
                (when (= row 0) 
                  (if (= col (1- *board-size*))
                      ;; top-right acute corner: yield top-right face to blue
                      (format stream "<polyline points='~A ~A' fill='none' stroke='#ff4d4d' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>~%" p-tl p-t)
                      ;; standard north edge
                      (format stream "<polyline points='~A ~A ~A' fill='none' stroke='#ff4d4d' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>~%" p-tl p-t p-tr)))
                
                ;; south border (red) - bottom-left and bottom-right faces
                (when (= row (1- *board-size*)) 
                  (if (= col 0)
                      ;; bottom-left acute corner: yield bottom-left face to blue
                      (format stream "<polyline points='~A ~A' fill='none' stroke='#ff4d4d' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>~%" p-b p-br)
                      ;; standard south edge
                      (format stream "<polyline points='~A ~A ~A' fill='none' stroke='#ff4d4d' stroke-width='6' stroke-linecap='round' stroke-linejoin='round'/>~%" p-bl p-b p-br)))
                
                ;; imprint cartesian coordinate (e.g. A1)
                (format stream "<text x='~A' y='~A' fill='~A'>~A</text>~%" 
                        cx (+ cy 1) text-color (nth 3 cell))))

            ;; game over overlay
            (when game-over-msg
              (let ((box-w 320) (box-h 60))
                (format stream "<rect x='~A' y='~A' width='~A' height='~A' fill='black' opacity='0.9' rx='8'/>~%" 
                        (- (/ width 2.0) (/ box-w 2.0)) (- (/ height 2.0) (/ box-h 2.0)) box-w box-h)
                (format stream "<text x='~A' y='~A' font-size='22' fill='white'>~A</text>~%" 
                        (/ width 2.0) (+ (/ height 2.0) 2) game-over-msg)))
            
            (format stream "</svg>~%"))))

    (with-open-file (out temp-filename :direction :output :if-exists :supersede :if-does-not-exist :create)
      (write-string svg-data out))
    (rename-file temp-filename filename)))

;;; --- Win Detection (BFS) ---

(defun check-win ()
  "Check if RED connected north to south, or BLUE connected west to east"
  (let ((red-starts nil) (red-targets nil)
        (blue-starts nil) (blue-targets nil))
    
    ;; 1. identify target borders
    (dolist (cell *cells*)
      (let ((id (nth 0 cell)) (row (nth 1 cell)) (col (nth 2 cell)) (status (nth 6 cell)))
        (when (eq status :red)
          (when (= row 0) (push id red-starts))                 ; north
          (when (= row (1- *board-size*)) (push id red-targets))) ; south
        (when (eq status :blue)
          (when (= col 0) (push id blue-starts))                 ; west
          (when (= col (1- *board-size*)) (push id blue-targets))))) ; east

    ;; 2. BFS for red
    (let ((queue red-starts) (visited nil))
      (loop while queue do
        (let ((curr (pop queue)))
          (unless (member curr visited)
            (push curr visited)
            (when (member curr red-targets)
              (return-from check-win 1)) ; red wins
            (dolist (n (gethash curr *adj*))
              (when (eq (nth 6 (get-cell n)) :red)
                (push n queue)))))))

    ;; 3. BFS for blue
    (let ((queue blue-starts) (visited nil))
      (loop while queue do
        (let ((curr (pop queue)))
          (unless (member curr visited)
            (push curr visited)
            (when (member curr blue-targets)
              (return-from check-win 2)) ; blue wins
            (dolist (n (gethash curr *adj*))
              (when (eq (nth 6 (get-cell n)) :blue)
                (push n queue)))))))
    nil))
  
;;; ===========================================================================
;;; --- AI Algorithms (Easy: Heuristics & Templates) ---
;;; ===========================================================================

(defun get-bridge-intrusions (player)
  "Scan opponent stones for existing bridges and return shared empty cells to block them"
  (let ((opp-status (if (= player 1) :blue :red))
        (blocks nil))
    (dolist (cell1 *cells*)
      (when (eq (nth 6 cell1) opp-status)
        (let ((id1 (first cell1)))
          (dolist (n1 (gethash id1 *adj*))
            (dolist (n2 (gethash n1 *adj*))
              (let ((cell2 (get-cell n2)))
                (when (and cell2 (eq (nth 6 cell2) opp-status) (< id1 n2))
                  (let ((shared-empty nil))
                    (dolist (common (gethash id1 *adj*))
                      (when (and (member common (gethash n2 *adj*))
                                 (eq (nth 6 (get-cell common)) :free))
                        (push common shared-empty)))
                    (when (= (length shared-empty) 2)
                      (setf blocks (append blocks shared-empty)))))))))))
    blocks))

(defun get-edge-template-moves (player)
  "Prioritize 'third-row template' anchors (row/col index 2 and N-3)"
  (let ((moves nil)
        (target-idx-1 2)
        (target-idx-2 (- *board-size* 3)))
    (dolist (cell (free-cells))
      (let ((id (first cell))
            (row (nth 1 cell))
            (col (nth 2 cell)))
        (if (= player 1)
            (when (or (= row target-idx-1) (= row target-idx-2)) (push id moves))
            (when (or (= col target-idx-1) (= col target-idx-2)) (push id moves)))))
    moves))

(defun get-center-biased-moves ()
  "Return list of free cells sorted by proximity to center of board"
  (let* ((center (/ (1- *board-size*) 2.0))
         (available (free-cells))
         (scored-moves nil))
    (dolist (cell available)
      (let* ((id (first cell))
             (row (nth 1 cell))
             (col (nth 2 cell))
             (dist (+ (expt (- row center) 2) (expt (- col center) 2))))
        (push (cons dist id) scored-moves)))
    (mapcar #'cdr (sort scored-moves #'< :key #'car))))

(defun ai-random-move (player)
  "Fallback AI: just pick a random free cell"
  (let ((available (free-cells)))
    (when available
      (first (nth (random (length available)) available)))))

(defun ai-easy-move (player)
  "Easy AI: win/block -> intrude bridges -> edge templates -> build bridges -> center bias."
  (let ((my-win (find-winning-move-hex player))
        (opp-win (find-winning-move-hex (if (= player 1) 2 1)))
        (intrusions (get-bridge-intrusions player))
        (edge-templates (get-edge-template-moves player))
        (bridges (get-bridge-moves player))
        (center-moves (get-center-biased-moves)))
    (cond
      (my-win my-win)                                         
      (opp-win opp-win)                                       
      (intrusions (nth (random (length intrusions)) intrusions)) 
      (edge-templates (nth (random (length edge-templates)) edge-templates)) 
      (bridges (nth (random (length bridges)) bridges))       
      (center-moves (first center-moves))                     
      (t (ai-random-move player)))))

;;; ===========================================================================
;;; --- AI Algorithms (Helpers) ---
;;; ===========================================================================

(defun simulate-and-check-hex (cell-id test-player)
  "Temporarily apply move to check if immediately wins game"
  (let ((original-status (nth 6 (get-cell cell-id)))
        (test-status (if (= test-player 1) :red :blue))
        (win-result nil))
    (update-cell-status cell-id test-status)
    (setf win-result (check-win))
    (update-cell-status cell-id original-status) ; backtrack
    (if (eq win-result test-player) t nil)))

(defun find-winning-move-hex (player)
  "Return cell-id of 1-move win if exists, otherwise NIL"
  (dolist (cell (free-cells))
    (let ((cell-id (first cell)))
      (when (simulate-and-check-hex cell-id player)
        (return-from find-winning-move-hex cell-id))))
  nil)

;;; ===========================================================================
;;; --- Virtual Connections & Global Dijkstra ---
;;; ===========================================================================

(defun get-active-bridges (player)
  "Scan board for bridges and return them as 0-cost edges"
  (let ((my-status (if (= player 1) :red :blue))
        (bridges nil))
    (dolist (cell1 *cells*)
      (when (eq (nth 6 cell1) my-status)
        (let ((id1 (first cell1)))
          (dolist (n1 (gethash id1 *adj*))
            (dolist (n2 (gethash n1 *adj*))
              (let ((cell2 (get-cell n2)))
                (when (and cell2 (eq (nth 6 cell2) my-status) (< id1 n2))
                  (let ((shared-empty 0))
                    (dolist (common (gethash id1 *adj*))
                      (when (and (member common (gethash n2 *adj*))
                                 (eq (nth 6 (get-cell common)) :free))
                        (incf shared-empty)))
                    (when (= shared-empty 2)
                      (push (cons id1 n2) bridges)
                      (push (cons n2 id1) bridges))))))))))
    bridges))

(defun hex-dijkstra (player)
  "Calculate shortest path, automatically treat bridges as 0-cost jumps"
  (let ((dist (make-hash-table))
        (queue nil)
        (my-status (if (= player 1) :red :blue))
        (target-nodes nil)
        (bridges (get-active-bridges player)))

    (dolist (cell *cells*)
      (let ((id (first cell)) (row (nth 1 cell)) (col (nth 2 cell)) (status (nth 6 cell)))
        (setf (gethash id dist) 9999) 
        
        (if (= player 1)
            (when (= row 0) 
              (if (eq status my-status)
                  (progn (setf (gethash id dist) 0) (push id queue))
                  (when (eq status :free) (setf (gethash id dist) 1) (push id queue))))
            (when (= col 0) 
              (if (eq status my-status)
                  (progn (setf (gethash id dist) 0) (push id queue))
                  (when (eq status :free) (setf (gethash id dist) 1) (push id queue)))))
        
        (if (= player 1)
            (when (= row (1- *board-size*)) (push id target-nodes))
            (when (= col (1- *board-size*)) (push id target-nodes)))))

    (loop while queue do
      (let ((curr nil) (min-d 9999))
        (dolist (node queue)
          (let ((d (gethash node dist)))
            (when (< d min-d)
              (setf min-d d)
              (setf curr node))))
        (setf queue (remove curr queue :count 1))

        (let ((d (gethash curr dist)))
          
          (dolist (neighbor (gethash curr *adj*))
            (let* ((n-status (nth 6 (get-cell neighbor)))
                   (weight (cond ((eq n-status my-status) 0)
                                 ((eq n-status :free) 1)
                                 (t 9999)))
                   (new-d (+ d weight)))
              (when (< weight 9999)
                (let ((old-d (gethash neighbor dist 9999)))
                  (when (< new-d old-d)
                    (setf (gethash neighbor dist) new-d)
                    (pushnew neighbor queue))))))
          
          (dolist (bridge bridges)
            (when (= (car bridge) curr)
              (let* ((neighbor (cdr bridge))
                     (new-d d))
                (let ((old-d (gethash neighbor dist 9999)))
                  (when (< new-d old-d)
                    (setf (gethash neighbor dist) new-d)
                    (pushnew neighbor queue)))))))))

    (let ((min-target 9999)
          (sum-target 0))
      (dolist (t-node target-nodes)
        (let ((d (gethash t-node dist 9999)))
          (when (< d min-target) (setf min-target d))
          (when (< d 9999) (incf sum-target d))))
      
      (if (= min-target 9999)
          999999 
          (+ (* min-target 1000) sum-target)))))

(defun evaluate-hex-board ()
  "Evaluate board from red's perspective: positive = red advantage, negative = blue advantage"
  (let ((red-dist (hex-dijkstra 1))
        (blue-dist (hex-dijkstra 2)))
    (- blue-dist red-dist)))
    
;;; ===========================================================================
;;; --- AI Algorithms (Medium: Depth-1 Global Dijkstra) ---
;;; ===========================================================================

(defun ai-medium-move (player)
  "Medium AI: depth 1 search: evaluates board globally using dijkstra"
  (let ((my-win (find-winning-move-hex player))
        (opp-win (find-winning-move-hex (if (= player 1) 2 1))))
    (when my-win (return-from ai-medium-move my-win))
    (when opp-win (return-from ai-medium-move opp-win)))

  (let ((best-move nil)
        (best-score (if (= player 1) -9999999 9999999))
        (available (free-cells)))

    (if (>= (length available) (- (* *board-size* *board-size*) 2))
        (return-from ai-medium-move (first (get-center-biased-moves))))

    (dolist (my-cell available)
      (let* ((my-id (first my-cell)))
        
        (update-cell-status my-id (if (= player 1) :red :blue))
        
        (let ((score (evaluate-hex-board)))
          (if (= player 1)
              (when (> score best-score)
                (setf best-score score best-move my-id))
              (when (< score best-score)
                (setf best-score score best-move my-id))))
        
        (update-cell-status my-id :free)))
    
    (or best-move (ai-easy-move player))))
    
;;; ===========================================================================
;;; --- AI Algorithms (Hard: Alpha-Beta Pruning & Dynamic Depth) ---
;;; ===========================================================================

(defun hex-alpha-beta (depth alpha beta is-maximizing)
  "Recursive minimax search with alpha-beta pruning"
  (let ((winner (check-win)))
    (cond
      ((eq winner 1) 9999999)  ; red wins
      ((eq winner 2) -9999999) ; blue wins
      ((<= depth 0) (evaluate-hex-board))
      (t
       (let ((available (get-center-biased-moves)))
         (if is-maximizing
             (let ((max-eval -10000000))
               (dolist (move available max-eval)
                 (update-cell-status move :red)
                 (let ((eval (hex-alpha-beta (1- depth) alpha beta nil)))
                   (update-cell-status move :free)
                   (setf max-eval (max max-eval eval))
                   (setf alpha (max alpha eval))
                   (when (<= beta alpha)
                     (return max-eval)))))
             (let ((min-eval 10000000))
               (dolist (move available min-eval)
                 (update-cell-status move :blue)
                 (let ((eval (hex-alpha-beta (1- depth) alpha beta t)))
                   (update-cell-status move :free)
                   (setf min-eval (min min-eval eval))
                   (setf beta (min beta eval))
                   (when (<= beta alpha)
                     (return min-eval)))))))))))

(defun ai-hard-move (player)
  "Hard AI: dynamic depth alpha-beta search using global dijkstra pathfinding"
  (let ((my-win (find-winning-move-hex player))
        (opp-win (find-winning-move-hex (if (= player 1) 2 1))))
    (when my-win (return-from ai-hard-move my-win))
    (when opp-win (return-from ai-hard-move opp-win)))

  (let* ((best-move nil)
         (available (get-center-biased-moves))
         (depth (if (< *board-size* 11) 3 2)))

    (if (>= (length available) (- (* *board-size* *board-size*) 2))
        (return-from ai-hard-move (first available)))

    (if (= player 1)
        (let ((best-val -10000000)
              (alpha -10000000)
              (beta 10000000))
          (dolist (move available)
            (update-cell-status move :red)
            (let ((val (hex-alpha-beta (1- depth) alpha beta nil)))
              (update-cell-status move :free)
              (when (> val best-val)
                (setf best-val val)
                (setf best-move move))
              (setf alpha (max alpha val)))))
        
        (let ((best-val 10000000)
              (alpha -10000000)
              (beta 10000000))
          (dolist (move available)
            (update-cell-status move :blue)
            (let ((val (hex-alpha-beta (1- depth) alpha beta t)))
              (update-cell-status move :free)
              (when (< val best-val)
                (setf best-val val)
                (setf best-move move))
              (setf beta (min beta val))))))
    
    (or best-move (ai-medium-move player))))

;;; ===========================================================================
;;; --- Game Router ---
;;; ===========================================================================

(defun ai-move (player)
  "Route AI decision based on selected difficulty level"
  (case *difficulty-level*
    (1 (ai-easy-move player))
    (2 (ai-medium-move player))
    (3 (ai-hard-move player))
    (otherwise (ai-hard-move player))))

;;; --- Game Loop (REPL) ---

(defun apply-move (cell-id player)
  (update-cell-status cell-id (if (= player 1) :red :blue))
  
  (let ((winner (check-win)))
    (if winner
        (let ((msg (if (= winner 1) "RED WINS! (N-S Connected)" "BLUE WINS! (W-E Connected)")))
          (draw-svg-board "current_hex_board.svg" msg)
          (format t "~%========================================~%")
          (format t "          ~A         ~%" msg)
          (format t "========================================~%")
          t) 
        (progn
          (draw-svg-board "current_hex_board.svg")
          (setf *current-player* (if (= player 1) 2 1))
          nil))))

(defun game-loop ()
  (loop
    (if (= *current-player* *human-role*)
        (progn
          (format t "~%~A's turn! Enter cell coordinate (e.g., 'A1' or 'C3') > " 
                  (if (= *human-role* 1) "RED" "BLUE"))
          (force-output)
          (let ((input (read-line *standard-input* nil :eof)))
            (when (eq input :eof) (return))
            (let ((cell (get-cell-by-label (string-trim " " input))))
              (if cell
                  (if (eq (nth 6 cell) :free)
                      (when (apply-move (first cell) *current-player*) (return))
                      (format t "Invalid move! Cell ~A is already occupied.~%" (nth 3 cell)))
                  (format t "Invalid input! Coordinate not found on board.~%")))))
        
        (progn
          (format t "~%AI (~A) is thinking...~%" (if (= *current-player* 1) "RED" "BLUE"))
          (sleep 0.5)
          (let ((move (ai-move *current-player*)))
            (if move
                (progn
                  (format t "AI claims cell ~A.~%" (nth 3 (get-cell move)))
                  (when (apply-move move *current-player*) (return)))
                (progn
                  (format t "AI has no valid moves! Board is full.~%")
                  (return))))))))

;;; --- Main Execution ---
(let ((args (cdr sb-ext:*posix-argv*)))
  (when (>= (length args) 4)
    (setf *board-size* (parse-integer (first args)))
    (setf *difficulty-level* (parse-integer (second args)))
    (setf *human-role* (parse-integer (third args)))
    (setf *current-player* (parse-integer (fourth args)))))

(init-board *board-size*)
(draw-svg-board "current_hex_board.svg")
(game-loop)
```