---
title: "DAWSON'S KAYLES: The Impartial Rank"
pubDatetime: 2024-12-01T00:00:00Z
description: "An exploration of Dawson's Kayles, combinatorial game theory, and a complete implementation in bash and lisp."
author: "Jerod Michel, Gao Yucheng"
tags: ["bash", "binary", "command line", "Dawson's Kayles", "perfect information", "math"]
---


# Dawson's Kayles
## The Impartial Rank

**Jerod Michel, Gao Yucheng**

<blockquote class="text-right ml-auto max-w-2xl italic mb-8 !border-none !pl-0">
  <p>"War is the realm of uncertainty; three quarters of the factors on which action in war is based are wrapped in a fog of greater or lesser uncertainty."</p>
  <p class="font-bold mt-2">— Carl von Clausewitz, <em>On War</em> (1832), Book 1, Chapter 3</p>
</blockquote>

## Description

Dawson's Kayles looks simple at first glance. There is a row of pawns from which players take turns removing any two that are adjacent. The last move wins. But don't be deceived.

## History
Dawson's Kayles was invented by Thomas Rayner Dawson (1889-1951), a British chess composer, and considered the "father of fairy chess". Dawson was incredibly prolific: he created over 5,000 chess problems, pioneered many fairy chess pieces (pieces whose movements are different from those of traditional chess pieces) and conditions, was editor of the "Fairy Chess Review", and made significant contributions to combinatorial game theory. Dawson's Kayles emerged in the 1930s when Dawson was exploring impartial games that could be analyzed using the Sprague-Grundy theorem. It's a variant of Kayles (which itself is a bowling-pin game) but reinterpreted as a chess-like game.

## Rules and Gameplay

*   **Setup**: Begin with a single row of $n$ identical tokens.
*   **Turn Order**: Two players alternate turns, starting with the first player.
*   **Legal Moves**: On each turn, a player must remove **exactly two adjacent tokens**.
*   **Move Restrictions**:
    *   Tokens removed must be contiguous (i.e., must be direct neighbors),
    *   A player cannot remove single tokens or three tokens,
    *   A player cannot skip a turn if a legal move exists.
*   **End Condition**: The game ends when no adjacent pair of tokens remains.
*   **Victory Condition**: The player who makes the last legal move wins. (This is considered *normal play*.)

**Mathematical Context**: Dawson's Kayles is an impartial game where each position decomposes into independent subgames, allowing analysis through nim-values (Grundy numbers) and the Sprague-Grundy theorem.

## Sprague-Grundy Theory

We begin with some basic concepts. The following provide a framework for analyzing games such as Dawson's Kayles through their underlying combinatorial structure.

<div class="definition">

**Definition (Combinatorial Game).**

A *combinatorial game* is a tuple $(P, M, p_0)$ where:
1. $P$ is a set of positions,
2. $M: P \to 2^P$ gives the set of moves from each position,
3. $p_0 \in P$ is the starting position,
4. players alternate moves, and
5. the game terminates in finite time (i.e., it is not an infinite sequence).

</div>

<div class="definition">

**Definition (Impartial Game).**

A combinatorial game is *impartial* if:
1. the set of available moves depends only on the position, and not on which player moves, and
2. both players have the same moves available from every position.

</div>

The impartiality condition is crucial for applying the Sprague-Grundy theory we will develop, as it ensures that both players face identical strategic situations.

<div class="definition">

**Definition (Normal Play Convention).**

Under *normal play*, the player who cannot move loses.

</div>

<div class="remark">

**Remark.**

Nim, which we discussed in Chapter 1, serves as the foundational example of an impartial game. Its significance stems from the Sprague-Grundy Theorem, which establishes that every impartial game, under normal play, is equivalent to a Nim heap. The nim-value of a position generalizes the concept of Nim heap sizes to arbitrary impartial games, providing a complete combinatorial invariant for game equivalence. Dawson's Kayles, while more structurally complex, inherits this theoretical framework and can be analyzed through the lens of nim-value calculus.

</div>

To systematically analyze such games it is convenient to use graphical representation.

<div class="definition">

**Definition (Game Graph).**

The *game graph* is a directed acyclic graph $G = (V,E)$ where:
1. $V$ is the set of game positions, and
2. $(u,v) \in E$ if and only if there exists a legal move from $u$ to $v$.

</div>

The following position types admit a recursive characterization that will form the computational core of our impartial game analysis.

<div class="definition">

**Definition (P- and N-Positions).**

For any position in an impartial combinatorial game under normal play:
1. a *P-position* is a position where the **P**revious player (the player who just moved) can force a win, and
2. an *N-position* is a position where the **N**ext player (the player about to move) can force a win.

</div>

The following lemma describes the recursive procedure underlying both the proof of the Sprague-Grundy theorem as well as practical computation of nim-values for Dawson's Kayles positions.

<div class="lemma">

**Lemma (Characterization of P/N-Positions).**

For any position $p$ in an impartial combinatorial game under normal play:
1. $p$ is a P-position if and only if every move from $p$ leads to an N-position, and
2. $p$ is an N-position if and only if there exists at least one move from $p$ to a P-position.

</div>

### Sprague-Grundy Theory

The true power of impartial game analysis emerges when we consider games which decompose into independent components.

<div class="definition">

**Definition (Disjunctive Sum of Games).**

The *disjunctive sum* of $n$ combinatorial games $G_1, G_2, \dots, G_n$, denoted $G_1 \oplus G_2 \oplus \cdots \oplus G_n$, is a game where:
1. a position is an $n$-tuple $(p_1, p_2, \dots, p_n)$ with $p_i$ a position in $G_i$,
2. a move consists of choosing exactly one component game $G_i$ and making a legal move in that component, and
3. the game ends when no moves are possible in any component.

</div>

Dawson's Kayles naturally decomposes into a disjunctive sum, as independent rows can be analyzed separately and their strategic values combined. We recall the following from our previous chapter.

<div class="definition">

**Definition (Minimum Excludant).**

For any subset $S \subseteq \mathbb{N}\cup\{0\}$, the *minimum excludant* of $S$ is given by:
$$
\text{mex}(S) = \min\{n \in \mathbb{N}_0 : n \notin S\}
$$

</div>

<div class="definition">

**Definition (Nim-value).**

The *nim-value* (or *Grundy number*) of a position $p$, denoted $\nim(p)$, is defined recursively as:
$$
\nim(p) = \text{mex}\{\nim(q) : q \in M(p)\}
$$
where $\text{mex}(S)$ (minimum excludant) of a set $S$ of nonnegative integers is the smallest nonnegative integer not in $S$.

</div>

The nim-value provides a refinement of the P/N-position classification: a position $p$ is a P-position if and only if $\nim(p) = 0$, and an N-position if and only if $\nim(p) > 0$. The following can be found in [WW82].

<div class="theorem">

**Theorem (Sprague-Grundy Theorem).**

Every impartial combinatorial game under normal play is equivalent to a Nim heap of size $\nim(p)$. Moreover, for a disjunctive sum of games $G = G_1 \oplus G_2 \oplus \cdots \oplus G_n$ with position $p = (p_1, p_2, \dots, p_n)$, the nim-value is given by:
$$
\nim(p) = \nim(p_1) \oplus \nim(p_2) \oplus \cdots \oplus \nim(p_n)
$$
where $\oplus$ denotes the nim-sum (bitwise XOR) operation.

</div>

**Proof:**
The proof proceeds by structural induction on the game graph. Notice the Nim-value correctly characterizes move options: from any position $p$ with $\nim(p) = n$, we have that for every $m < n$ there exists a move to some position $q$ with $\nim(q) = m$, but no move to a position distinct from $p$ with nim-value $n$. Notice also that the disjunctive sum $G_1 \oplus \cdots \oplus G_n$ with position $p = (p_1, \dots, p_n)$, we may let $N = \nim(p_1) \oplus \cdots \oplus \nim(p_n)$. Then for any $t$ with $0 \leq t < N$, there exists an index $i$ and a move $p_i \to q_i$ in $G_i$ such that:
$$
\nim(p_1) \oplus \cdots \oplus \nim(q_i) \oplus \cdots \oplus \nim(p_n) = t.
$$
This mirrors the Nim strategy of reducing a single heap to achieve the desired nim-sum. The terminal position (where no legal move is available) has nim-value 0, and all moves from a position with nim-value 0 must lead to positions with positive nim-values. This establishes that the game is strategically equivalent to playing Nim with heap sizes equal to the nim-values of the component positions.
$\blacksquare$

We recall the following from Chapter 1.

<div class="definition">

**Definition (Nim-sum).**

Let $a = \sum a_k 2^k$ and $b = \sum b_k 2^k$, where $a_k, b_k \in \{0,1\}$ for $k \in \mathbb{N}$, be the binary expansions for nonnegative integers $a$ and $b$ respectively. The *nim-sum* $a$ and $b$, denoted $a \oplus b$, is given by
$$
a \oplus b = \sum_{k} \left((a_k + b_k) \bmod 2\right) 2^k.
$$
This operation is equivalent to bitwise exclusive OR (XOR) and extends to multiple operands associatively.

</div>

We now have a framework that allows us to analyze Dawson's Kayles by computing nim-values for various board configurations.

## The Winning Strategy

Recall that, initially, the game consists of $n$ tokens arranged in a single row, where players take turns removing exactly two adjacent tokens. This typically splits the row into independent segments, thereby making the disjunctive sum immediately applicable.

### Position Decomposition

Let $D(n)$ denote a Dawson's Kayles position with $n$ contiguous pawns. Removing two adjacent pawns at positions $k$ and $k+1$ decomposes the position into a disjunctive sum:
$$
D(n) \rightarrow D(k-1) \oplus D(n-k-1) \quad \text{for } k = 1, 2, \dots, n-1,
$$
where $D(0)$ represents the empty position with nim-value $0$.

### Computing nim-values for Dawson's Kayles

The nim-values for Dawson's Kayles follow the recurrence:
$$
\nim(D(n)) = \text{mex} \left\{ \nim(D(k-1)) \oplus \nim(D(n-k-1)) : k = 1, 2, \dots, n-1 \right\}
$$
with base cases $\nim(D(0)) = 0$ and $\nim(D(1)) = 0$ (as removing a single pawn is not a legal move).

The first few values computed via this recurrence are:
$$
\begin{aligned}
\nim(D(2)) &= \text{mex}\{0 \oplus 0\} = 1 \\
\nim(D(3)) &= \text{mex}\{0 \oplus 0,\ 0 \oplus 0\} = 1 \\
\nim(D(4)) &= \text{mex}\{0 \oplus 1,\ 0 \oplus 0,\ 1 \oplus 0\} = 2 \\
\nim(D(5)) &= \text{mex}\{0 \oplus 1,\ 0 \oplus 1,\ 1 \oplus 0,\ 1 \oplus 0\} = 0 \\
\nim(D(6)) &= \text{mex}\{0 \oplus 2,\ 0 \oplus 1,\ 1 \oplus 1,\ 1 \oplus 0,\ 2 \oplus 0\} = 3 \\
\nim(D(7)) &= \text{mex}\{0 \oplus 0,\ 0 \oplus 2,\ 1 \oplus 1,\ 1 \oplus 1,\ 2 \oplus 0,\ 0 \oplus 0\} = 1 \\
\nim(D(8)) &= \text{mex}\{0 \oplus 3,\ 0 \oplus 0,\ 1 \oplus 1,\ 1 \oplus 1,\ 2 \oplus 1,\ 0 \oplus 0,\ 3 \oplus 0\} = 1
\end{aligned}
$$

These values provide the foundation for optimal play. For example, $\nim(D(6)) = 3$ and $\nim(D(4)) = 2$.

### Periodicity and Patterns

A remarkable feature of Dawson's Kayles is the eventual periodicity of its nim-value sequence. The following can be found in [WW82].

<div class="theorem">

**Theorem (Periodicity of Dawson's Kayles).**

The nim-values for Dawson's Kayles are eventually periodic with period 34, starting at $n = 52$.

</div>

**Proof:**
Let $G(n) = \nim(D(n))$. Since moves only affect heaps of size $<n$, the recurrence is given by
$$
G(n) = \text{mex}\{G(i) \oplus G(j) : n \rightarrow (i,j) \text{ via legal move}\}.
$$

Let $M$ be the maximum nim-value observed (empirically $M \leq 3$). Consider the sequence of state vectors $\vec{S}_k = (G(k), G(k+1), \dots, G(k+33))$ for $k \geq 0$, where $\vec{S}_k \in \{0,1,\dots,M\}^{34}$, a finite set of size at most $(M+1)^{34}$.

By the pigeonhole principle, there must exist indices $a < b$ such that $\vec{S}_a = \vec{S}_b$. We show that periodicity begins at $a$ with period $p = b-a$, and proceed with induction on $n \geq a$.

1.  **Base**: For $n = a, a+1, \dots, a+33$, we have $G(n) = G(n+p)$ by the state vector equality.
2.  **Inductive hypothesis**: Assume $G(m) = G(m+p)$ for all $m < n$ with $n \geq a+34$. Then
    $$
    \begin{aligned}
    G(n+p) &= \text{mex}\{G(i+p) \oplus G(j+p) : \text{moves from } n+p\} \\
    &= \text{mex}\{G(i) \oplus G(j) : \text{moves from } n\} \\
    &= G(n) 
    \end{aligned}
    $$
    Where the second line holds by the inductive hypothesis, as equivalent moves from $n$ and $n+p$ must produce identical nim-sums.

That this occurs with period 34, starting at $n = 52$, is a straightforward computation.
$\blacksquare$

The periodicity enables one to compute winning strategies for arbitrarily large positions, as only a finite number of nim-values are needed.

### Winning Strategy Derivation

The winning strategy follows directly from the Sprague-Grundy Theorem:

1.  For a position consisting of multiple contiguous blocks $D(n_1) \oplus D(n_2) \oplus \cdots \oplus D(n_k)$, we compute the nim-sum
    $$
    S = \nim(D(n_1)) \oplus \nim(D(n_2)) \oplus \cdots \oplus \nim(D(n_k)).
    $$
2.  If $S = 0$, the position is a losing one for the player about to move (i.e., a P-position).
3.  If $S \neq 0$, a winning move exists in some block $D(n_i)$ where the player can move to a position $D(m)$ such that
    $$
    \nim(D(m)) = \nim(D(n_i)) \oplus S.
    $$
    This ensures the nim-sum becomes $0$.

This demonstrates how Dawson's Kayles reduces to nim-value calculations via Sprague-Grundy theory.

## Example of Play

Consider the position $D(6) \oplus D(4)$. We have $\nim(D(6)) = 3$ and $\nim(D(4)) = 2$, so the nim-sum is $3 \oplus 2 = 1 \neq 0$. This is an N-position, so the next player (let's call her Alice) can win.

Alice needs to find a move in one of the rows that changes the nim-sum to 0. She looks for a move in $D(6)$ that will leave a position with nim-value $3 \oplus 1 = 2$. One such move is removing tokens 1 and 2 from the $D(6)$ row, which leaves $D(4)$ in that row, and $\nim(D(4)) = 2$. Then the new position is $D(4) \oplus D(4)$ with nim-sum $2 \oplus 2 = 0$, a P-position.

Figure 1 illustrates this move.

![Example winning move in Dawson's Kayles](/dawskayl0.png)

### Game Progression

Let's trace through a complete game sequence:

1.  **Initial**: $D(6) \oplus D(4)$ with nim-sum $1 \oplus 0 = 1$ (N-position)
2.  **Alice's move**: Removes tokens 1 and 2 from $D(6)$, leaving $D(4) \oplus D(4)$ with nim-sum $0 \oplus 0 = 0$ (P-position)
3.  **Bob's move**: From $D(4) \oplus D(4)$, Bob must move in one component. Suppose he removes token 2 from the first $D(4)$ (removing tokens 1-3), leaving $D(1) \oplus D(4)$ with nim-sum $1 \oplus 0 = 1$ (N-position)
4.  **Alice's response**: Alice computes $\nim(D(1)) = 1$, $\nim(D(4)) = 0$, so $S = 1$. She needs to move to a position with nim-sum 0. She can remove token 1 from $D(1)$ (leaving $D(0)$), resulting in $D(4)$ alone with nim-sum 0.
5.  **Final moves**: Bob faces $D(4)$ (nim-value 0, P-position) and has no winning moves. Whatever he does, Alice can mirror or respond to maintain the winning position.

This example demonstrates how the theoretical framework translates to practical play: computing nim-sums, identifying winning moves through nim-value manipulation, and executing the winning strategy.

## Play Dawson's Kayles in Command Line

```bash
#!/bin/bash

# NIM Game in Bash with Machine Learning-inspired difficulty levels

# game state variables
declare -A board
declare -a blocks
declare -a grundy_numbers=(0 0 1 1 2 0 3 1 1 0 3 3 2 2 4 0 5 2 2 3 3 0 1)
current_player="human"
difficulty="medium"

# function to display the game board
display_board() {
    echo "Current board:"
    
    # display pawns
    for ((i=1; i<=$n; i++)); do
        if [ ${board[$i]} -eq 1 ]; then
            printf " ● "  # filled circle for pawn
        else
            printf "   "  # empty space
        fi
    done
    printf "\n"
    
    # display position numbers beneath
    for ((i=1; i<=$n; i++)); do
        printf " %-2d" $i  # numbers aligned under each position
    done
    printf "\n"
}

# function to calculate nim-sum (XOR of all rows)
calculate_nim_sum() {
    local sum=0
    for pawns in "${blocks[@]}"; do
        sum=$((sum ^ pawns))
    done
    echo $sum
}

# function to get current blocks from the board
get_blocks() {
    blocks=()
    local current_block=0
    
    for ((i=1; i<=n; i++)); do
        if [ ${board[$i]} -eq 1 ]; then
            ((current_block++))
        else
            if [ $current_block -gt 0 ]; then
                blocks+=($current_block)
                current_block=0
            fi
        fi
    done
    
    if [ $current_block -gt 0 ]; then
        blocks+=($current_block)
    fi
}

# function to find optimal move
find_optimal_move() {
    get_blocks
    local nim_sum=$(calculate_nim_sum)
    
    # if nim-sum is 0, any move is losing, so return to random
    if [ $nim_sum -eq 0 ]; then
        echo "random"
        return
    fi
    
    # try to find a move that gives nim-sum 0
    for ((pos=1; pos<n; pos++)); do
        # check if we can remove tokens at pos and pos+1 (exactly two adjacent tokens)
        if [ ${board[$pos]} -eq 1 ] && [ ${board[$((pos+1))]} -eq 1 ]; then
            # create temporary board to test move
            declare -A temp_board
            for ((i=1; i<=n; i++)); do
                temp_board[$i]=${board[$i]}
            done
            
            # remove exactly two adjacent tokens
            temp_board[$pos]=0
            temp_board[$((pos+1))]=0
            
            # calculate new blocks and nim-sum
            local temp_blocks=()
            local current_block=0
            for ((i=1; i<=n; i++)); do
                if [ ${temp_board[$i]} -eq 1 ]; then
                    ((current_block++))
                else
                    if [ $current_block -gt 0 ]; then
                        temp_blocks+=($current_block)
                        current_block=0
                    fi
                fi
            done
            [ $current_block -gt 0 ] && temp_blocks+=($current_block)
            
            # calculate new nim-sum
            local new_nim=0
            for block in "${temp_blocks[@]}"; do
                new_nim=$((new_nim ^ grundy_numbers[block]))
            done
            
            if [ $new_nim -eq 0 ]; then
                echo $pos
                return
            fi
        fi
    done
    
    echo "random"
}

# computer move implementation
computer_move() {
    echo "Computer is thinking..."
    sleep 1
    
    local move_type=""
    
    case $difficulty in
        "easy")
            # always play randomly
            move_type="random"
            ;;
        "medium")
            # 70% optimal, 30% random
            local rand=$((RANDOM % 10))
            if [ $rand -lt 7 ]; then
                move_type=$(find_optimal_move)
            else
                move_type="random"
            fi
            ;;
        "hard")
            # always play optimally
            move_type=$(find_optimal_move)
            ;;
    esac
    
    local position
    if [ "$move_type" = "random" ]; then
        # find all available starting positions for pairs
	local available_positions=()
	for ((i=1; i<n; i++)); do
		if [ ${board[$i]} -eq 1 ] && [ ${board[$((i+1))]} -eq 1 ]; then
		    available_positions+=($i)
		fi
	done
        
        if [ ${#available_positions[@]} -eq 0 ]; then
            echo "No moves available!"
            return
        fi
        
        local random_index=$((RANDOM % ${#available_positions[@]}))
        position=${available_positions[$random_index]}
    else
        position=$move_type
    fi
    
    # apply the move - remove exactly two adjacent tokens
	local start=$position
	local end=$((position + 1))

	# check if this is a valid move (both positions exist and have pawns)
	if [ $end -gt $n ] || [ ${board[$start]} -eq 0 ] || [ ${board[$end]} -eq 0 ]; then
		echo "Invalid move - cannot remove tokens $start and $((start+1))"
		return 1
	fi

	# remove the two adjacent pawns
	board[$start]=0
	board[$end]=0
}

# update human_move to actually apply the move
human_move() {
    while true; do
        echo "Enter the position number to remove (1-$n):"
        read position
        
        # check if input is valid number
        if ! [[ "$position" =~ ^[0-9]+$ ]]; then
            echo "Please enter a valid number."
            continue
        fi
        
        # check if position within bounds
        if [ $position -lt 1 ] || [ $position -gt $n ]; then
            echo "Position must be between 1 and $n."
            continue
        fi
        
        # check if position has a pawn
        if [ ${board[$position]} -eq 0 ]; then
            echo "Position $position is already empty."
            continue
        fi
        
        # check if position forms valid pair with neighbor
		if [ $position -eq $n ] || [ ${board[$((position+1))]} -eq 0 ]; then
			echo "Position $position cannot form a valid pair with its right neighbor."
			continue
		fi
        
        break
    done
    
    # apply move - remove exactly two adjacent tokens
	local start=$position
	local end=$((position + 1))

	# check if this is a valid move (both positions exist and have pawns)
	if [ $end -gt $n ] || [ ${board[$start]} -eq 0 ] || [ ${board[$end]} -eq 0 ]; then
		echo "Invalid move - cannot remove tokens $start and $((start+1))"
		return 1
	fi

	# remove the two adjacent pawns
	board[$start]=0
	board[$end]=0
}

# function to check if game is over
game_over() {
    get_blocks
    local total=0
    for pawns in "${blocks[@]}"; do
        if [[ $pawns -gt 1 ]]; then
            ((total++))
        fi
    done
    [ $total -eq 0 ]
}

# function to get initial game setup
setup_game() {
    echo "Welcome to DAWSON'S KAYLES!"
    echo
    
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
    
    # length setup
    echo "Set up the initial number of pawns (max 22 pawns):"
    while true; do
        read -p "Stones for number of pawns (1-22): " n
        
        if [[ ! "$n" =~ ^[0-9]+$ ]] || [ $n -lt 1 ] || [ $n -gt 22 ]; then
            echo "Please enter a number between 1 and 22."
            continue
        fi
        break
    done
    
    # who goes first (player choice)
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

	# initialize board with pawns
	for ((i=1; i<=n; i++)); do
		board[$i]=1
	done

	# initialize blocks as single contiguous block
	blocks=($n)

	echo "$current_player will go first!"
}

# main game loop
main() {
    setup_game
    
    while true; do
        display_board
        
        if game_over; then
	    if [ "$current_player" = "human" ]; then
		echo "Game over! You took the last stone. Computer wins!"
	    else
		echo "Game over! Computer took the last stone. You win!"
	    fi
	    break
	fi
        
        if [ "$current_player" = "human" ]; then
            human_move
            current_player="computer"
        else
            computer_move
            current_player="human"
        fi
    done
    
    echo
    read -p "Play again? (y/n): " play_again
	if [[ $play_again =~ ^[Yy]$ ]]; then
		# reset all game state and restart
		unset board blocks
		declare -A board
		declare -a blocks
		current_player="human"
		difficulty="medium"
		main
	else
		echo "Thanks for playing DAWSON'S KAYLES!"
		exit 0
	fi
}

# start the game
main
```

**References:**
* Berlekamp, E. R., Conway, J. H., and Guy, R. K. (1982). *Winning Ways for your Mathematical Plays*, volumes 1 and 2. Academic Press, London.