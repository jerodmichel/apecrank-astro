---
title: "NIM: The Thief and the Warhead"
pubDatetime: 2024-12-01T00:00:00Z
description: "An exploration of NIM, combinatorial game theory, and a complete Bash implementation."
author: "Jerod Michel, Gao Yucheng"
tags: ["bash", "binary", "command line", "NIM", "perfect information", "math"]
---

<blockquote class="text-right ml-auto max-w-2xl italic mb-8 !border-none !pl-0 before:content-none after:content-none [quotes:none]">
  <p>"When a prince is brave and powerful, he can make peace reign as and when he wants. If, however, he has no powers, someone stronger than him will conquer his lands and rule at his pleasure."</p>
  <p class="font-bold mt-2">— Vlad Dracul III, Letter to the elders of Brașov, 1456</p>
</blockquote>

## Description

Despite its simple rules, Nim is a game of pure logic with a guaranteed winning strategy for one of the players if they play perfectly. The optimal strategy is based on binary digital sums (or, *nim-sums*). A player in a losing position, then, can win only if their opponent makes a mistake.

In essence, Nim is a foundational game in the field of combinatorial game theory and is a perfect example of a two-player, finite, impartial game with perfect information.

## History

The origins of NIM are obscure, but certainly very old, and probably began in China as a game called "捡石头" (Jiǎn shítou). The name "NIM" is also a mystery. It was likely coined by the Harvard mathematician Charles L. Bouton, who was the first to published a mathematical analysis of the game in the Annals of Mathematics in 1901. One theory is that he took it from the archaic English verb nim, meaning "to take" or "to steal".	

*   **NIMATRON (1940)**: An electro-mechanical beast built by Westinghouse for the 1940 World's Fair. It was a public spectacle, a "robot" that could play a perfect game. It won 90% of its games against humans, mostly by intimidating them into mistakes—a valid example of psychological warfare augmented by machinery.
*   **FERMIAC (1947)**: Built by physicist Stanislaw Ulam (of H-bomb and Monte Carlo method fame), this was a portable computer designed to simulate neutron transport. But its first public demonstration? Playing and winning a game of NIM. The line between a weapon of science and a game was blurred from the very start.
*   **The MANIAC (1952)**: At Los Alamos National Laboratory—the birthplace of the atomic bomb—the mathematicians and computer scientists needed a way to test the power of their new machine, the MANIAC I. What was one of the very first tasks they programmed? A perfect NIM-playing algorithm.
    
## Rules and Gameplay
    
*   **Setup**: The game starts with several rows (or heaps) of objects, such as stones or matches. A common initial setup is that with three rows containing 3, 5, and 7 objects.
*   **Gameplay**: Players take turns. On a player's turn, they must remove one or more objects from a single row of their choosing. They may take as many objects as they want (from a single object up to the entire row) from this chosen row.
*   **Winning**: The player who is forced to take the last object loses. (Note that this is the "misère" convention. In the "normal" version, the player who takes the last object wins).
    
The complete strategy, solved by Charles L. Bouton in 1901, is based on a binary operation called the **nim-sum**.

## The Nim-Sum

The **nim-sum** of non-negative integers is their addition in base 2 *without carry*. It is denoted by the symbol "$\oplus$" (XOR, exclusive OR). Every nonnegative integer has a unique binary representation, which allows us to define this operation precisely.

### Computing the Nim-sum

To compute the nim-sum of rows of sizes $a$, $b$, $c$, $\dots$:
1. Write each number in base 2 (binary), using the unique binary representation of each nonnegative integer.
2. Align the numbers by their binary digits, padding with leading zeros as needed so all numbers have the same number of digits.
3. For each column (bit position), perform addition modulo 2:
   $0 \oplus 0 = 0$, $1 \oplus 0 = 1$, $0 \oplus 1 = 1$, $1 \oplus 1 = 0$.
4. The resulting binary string is the nim-sum.

### Example

Let's compute the nim-sum of rows of size 3, 5, and 7, using their binary representations. We write each number with the same number of digits by padding with leading zeros:

$$
\begin{aligned}
    3 &= 0\cdot2^2 + 1\cdot2^1 + 1\cdot2^0 = (011)_2 \\
    5 &= 1\cdot2^2 + 0\cdot2^1 + 1\cdot2^0 = (101)_2 \\
    7 &= 1\cdot2^2 + 1\cdot2^1 + 1\cdot2^0 = (111)_2 \\
    \text{Nim-sum} &= (001)_2 = 1 \\
    \text{Calculation: } & \begin{array}{c@{\,}c@{\,}c@{\,}c}
        & 0 & 1 & 1 \\
    \oplus & 1 & 0 & 1 \\
    \oplus & 1 & 1 & 1 \\
    \hline
        & 0 & 0 & 1
    \end{array}
\end{aligned}
$$

The nim-sum is 1.

## The Winning Strategy

<div class="definition">

**Definition** 

*   A game state is *balanced* if its nim-sum is $0$.
*   A game state is *unbalanced* if its nim-sum is not $0$.

</div>

<div class="theorem">

**Theorem** 

1.  **If a player is presented with a *balanced* position ($nim\text{-}sum = 0$), any move they make will necessarily leave an *unbalanced* position.**
2.  **If a player is presented with an *unbalanced* position ($nim\text{-}sum \neq 0$), there always exists at least one move that will leave a *balanced* position.**
3.  **The final position (all rows size 0) is balanced ($0 \oplus 0 \oplus \dots \oplus 0 = 0$).**

</div>

Therefore, the winning strategy is: **Always move to leave your opponent with a balanced position.**

<div class="proof">

Let the rows be $a_1, a_2, \dots, a_n$ and let $s = a_1 \oplus a_2 \oplus \dots \oplus a_n$.

**Proof of (1): From a balanced position, all moves lead to an unbalanced position.**

Suppose $s = 0$. A player's move changes the size of one row, say $a_k$, to a new value $a'_k$ where $a'_k < a_k$. We will show this new position is unbalanced.

Consider the new nim-sum $s' = a_1 \oplus \dots \oplus a'_k \oplus \dots \oplus a_n$.
We know:

$$
\begin{aligned} 
s &= 0 = a_1 \oplus \dots \oplus a_k \oplus \dots \oplus a_n \\ 
\Rightarrow a_k &= a_1 \oplus \dots \oplus a_{k-1} \oplus a_{k+1} \oplus \dots \oplus a_n 
\end{aligned}
$$

Now, substitute into the expression for $s'$:

$$
\begin{align*} s' &= (a_1 \oplus \dots \oplus a_{k-1} \oplus a_{k+1} \oplus \dots \oplus a_n) \oplus a'_k \\\\ s' &= a_k \oplus a'_k 
\end{align*}
$$

Since $a'_{k} \neq a_k$, it follows that $a_{k} \oplus a'_k \neq 0$. Therefore, $s' \neq 0$.<div class="text-right">$\square$</div>

**Proof of (2): From an unbalanced position, there exists a move to a balanced position.**

Suppose $s \neq 0$. Let $d$ be the position of the most significant (leftmost) 1-bit in the binary representation of $s$.

There must be at least one row, say $a_{k}$, that also has a 1 in bit position $d$ (because if all rows had 0 there, the nim-sum would have 0 in that position).

We choose this row $a_{k}$ to make our move. We will reduce $a_{k}$ to $a'_{k} = a_{k} \oplus s$.

We must verify two things:

1.  **This is a valid move:** $a'_{k} < a_{k}$.
    The operation $a_{k} \oplus s$ affects bits only from position $d$ downwards. Because $a_{k}$ and $s$ both have a 1 in bit $d$, $a_{k} \oplus s$ will have a 0 in bit $d$. All higher bits remain unchanged. Thus, $a'_k$ is indeed smaller than $a_{k}$.
2.  **This move creates a balanced position:**
    The new nim-sum $s'$ is:
    
    $$
    \begin{align*}
         s' &= a_{1} \oplus \dots \oplus a'_{k} \oplus \dots \oplus a_{n} \\\\        &= a_{1} \oplus \dots \oplus (a_{k} \oplus s) \oplus \dots \oplus a_{n} \\\\        &= (a_{1} \oplus \dots \oplus a_{k} \oplus \dots \oplus a_{n}) \oplus s \\\\        &= s \oplus s \\\\        &= 0     
    \end{align*}
    $$
    
    The new position is balanced.<div class="text-right">$\square$</div>

</div>

## Example of Play

Let's play a game with rows as (3, 5, 7). As calculated earlier, $3 \oplus 5 \oplus 7 = 1.$ This is an *unbalanced* position. Player 1 (the winning player) must find a move that makes the nim-sum 0.

They compute for each row:
*   Row 1: $3 \oplus 1 = 2$. (Valid move: remove 1 from row 1 to leave 2).
*   Row 2: $5 \oplus 1 = 4$. (Valid move: remove 1 from row 2 to leave 4).
*   Row 3: $7 \oplus 1 = 6$. (Valid move: remove 1 from row 3 to leave 6).

Player 1 chooses one of these moves, say, taking 1 from row 3, leaving rows as (3, 5, 6). The new nim-sum is $3 \oplus 5 \oplus 6 = 0$, a balanced position for Player 2. From here, whatever Player 2 does, Player 1 can always return the game to a balanced position, eventually taking the last object.

<div class="remark">

In NIM there is always a linchpin—a single point of failure upon which the entire structure of the game is precariously balanced. The uninitiated see three separate (and possibly dissimilar) rows; the strategist sees a single, hidden device: the nim-sum.

</div>

## Play Nim in Command Line

In crafting this NIM implementation, we embrace Bash not as a limitation but as a vehicle for clarity. The game states are maintained in simple arrays, where each element represents a row of stones. This minimalist data structure contrasts well with the strategic depth we have coded within the AI routines. 

The AI employs the mathematical foundation of combinatorial game theory through the nim-sum calculation (bitwise XOR operations), transforming the game into an elegant exercise in binary arithmetic. For the easy difficulty, random moves simulate those of a novice player, while the medium AI introduces some probabilistic decision-making, occasionally 'forgetting' optimal strategies to create a more human-like opponent. The hard AI fully implements the classic winning algorithm. This implementation demonstrates how, even in a shell scripting environment, we can encode sophisticated game theory concepts that respond intelligently to player input while remaining computationally transparent.

The result is a didactic tool where the reader can trace the exact logic behind each computer move, watching the nim-sum calculations unfold in real time as the AI navigates the game tree according to proven mathematical principles.

```bash
#!/bin/bash

# NIM Game in Bash with Machine Learning-inspired difficulty levels

# game state variables
declare -a rows
current_player="human"
difficulty="medium"
learning_rate=0.1  # For medium difficulty "learning" simulation

# function to display the game board
display_board() {
    echo
    echo "=== NIM GAME ==="
    echo "Rows:"
    for i in "${!rows[@]}"; do
        stones=""
        for ((j=0; j<${rows[i]}; j++)); do
            stones+="● "
        done
        echo "Row $((i+1)) [${rows[i]} stones]: $stones"
    done
    echo
}

# function to calculate nim-sum (XOR of all rows)
calculate_nim_sum() {
    local sum=0
    for stones in "${rows[@]}"; do
        sum=$((sum ^ stones))
    done
    echo $sum
}

# function to find the optimal move for hard difficulty
find_optimal_move() {
    local nim_sum=$(calculate_nim_sum)
    local non_one_rows=0
    local rows_with_more_than_one=0
    
    # count rows with more than 1 stone
    for stones in "${rows[@]}"; do
        if [ $stones -gt 1 ]; then
            ((rows_with_more_than_one++))
            ((non_one_rows++))
        elif [ $stones -eq 1 ]; then
            ((non_one_rows++))
        fi
    done
    
    # in misere Nim, strategy differs when all rows are 1 stone
    if [ $rows_with_more_than_one -eq 0 ]; then
        # all rows have 0 or 1 stones - odd number of 1's means take 1, even means take all?
        # actually, in misere with all 1's: odd number of rows -> take 1 to leave even
        local ones_count=0
        for stones in "${rows[@]}"; do
            if [ $stones -eq 1 ]; then
                ((ones_count++))
            fi
        done
        
        if [ $((ones_count % 2)) -eq 1 ]; then
            # edd number of 1's - take 1 to leave even number for opponent
            for i in "${!rows[@]}"; do
                if [ ${rows[i]} -eq 1 ]; then
                    echo "$i 1"
                    return
                fi
            done
        else
            # even number of 1's - take all from first available row
            for i in "${!rows[@]}"; do
                if [ ${rows[i]} -eq 1 ]; then
                    echo "$i 1"
                    return
                fi
            done
        fi
    fi
    
    # if nim-sum is 0, no optimal move exists - take from largest row but leave good position
    if [ $nim_sum -eq 0 ]; then
        # take 1 from the first available row (losing position anyway)
        for i in "${!rows[@]}"; do
            if [ ${rows[i]} -gt 0 ]; then
                echo "$i 1"
                return
            fi
        done
    fi
    
    # find a move that makes nim-sum 0, but avoid leaving bad misère positions
    for i in "${!rows[@]}"; do
        local target=$(( ${rows[i]} ^ $nim_sum ))
        if [ $target -lt ${rows[i]} ]; then
            local take=$(( ${rows[i]} - $target ))
            
            # check if this move leaves only 1-stone rows (dangerous in misere)
            local temp_rows=("${rows[@]}")
            temp_rows[i]=$target
            local remaining_multi_stone=0
            for stones in "${temp_rows[@]}"; do
                if [ $stones -gt 1 ]; then
                    ((remaining_multi_stone++))
                fi
            done
            
            # if this would leave only single stones, make sure we leave odd number
            if [ $remaining_multi_stone -eq 0 ]; then
                local ones_count=0
                for stones in "${temp_rows[@]}"; do
                    if [ $stones -eq 1 ]; then
                        ((ones_count++))
                    fi
                done
                # we want to leave odd number of 1's for opponent in misere
                if [ $((ones_count % 2)) -eq 1 ]; then
                    echo "$i $take"
                    return
                fi
            else
                echo "$i $take"
                return
            fi
        fi
    done
    
    # fallback: take 1 from first available row
    for i in "${!rows[@]}"; do
        if [ ${rows[i]} -gt 0 ]; then
            echo "$i 1"
            return
        fi
    done
}

# function for computer's move
computer_move() {
    echo "Computer's turn..."
    sleep 1
    
    local nim_sum=$(calculate_nim_sum)
    local row_to_take stones_to_take
    
    case $difficulty in
        "easy")
            # random valid move
            while true; do
                local random_row=$(( RANDOM % ${#rows[@]} ))
                if [ ${rows[random_row]} -gt 0 ]; then
                    local max_take=${rows[random_row]}
                    stones_to_take=$(( (RANDOM % max_take) + 1 ))
                    row_to_take=$random_row
                    break
                fi
            done
            ;;
            
        "medium")
            # sometimes optimal, sometimes random (simulating learning)
            local random_choice=$(( RANDOM % 100 ))
            if [ $random_choice -lt 70 ]; then  # 70% chance of optimal move
                read row_to_take stones_to_take <<< $(find_optimal_move)
            else
                # random move
                while true; do
                    local random_row=$(( RANDOM % ${#rows[@]} ))
                    if [ ${rows[random_row]} -gt 0 ]; then
                        local max_take=${rows[random_row]}
                        stones_to_take=$(( (RANDOM % max_take) + 1 ))
                        row_to_take=$random_row
                        break
                    fi
                done
            fi
            ;;
            
        "hard")
            # always optimal move
            read row_to_take stones_to_take <<< $(find_optimal_move)
            ;;
    esac
    
    # execute the move
    rows[row_to_take]=$(( ${rows[row_to_take]} - stones_to_take ))
    echo "Computer takes $stones_to_take stone(s) from row $((row_to_take + 1))"
}

# function for human player's move
human_move() {
    while true; do
        echo "Your turn! Enter row number and stones to take (e.g., '2 3' for row 2, 3 stones):"
        read -p "> " input
        
        # parse input
        local row_num=$(echo $input | awk '{print $1}')
        local take_num=$(echo $input | awk '{print $2}')
        
        # validate input
        if [[ ! "$row_num" =~ ^[1-3]$ ]] || [[ ! "$take_num" =~ ^[0-9]+$ ]]; then
            echo "Invalid input! Please enter: row(1-3) stones(number)"
            continue
        fi
        
        local row_index=$((row_num - 1))
        
        if [ ${rows[row_index]} -eq 0 ]; then
            echo "Row $row_num is empty! Choose another row."
            continue
        fi
        
        if [ $take_num -lt 1 ] || [ $take_num -gt ${rows[row_index]} ]; then
            echo "Invalid number of stones! You can take 1 to ${rows[row_index]} from row $row_num."
            continue
        fi
        
        # valid move - execute it
        rows[row_index]=$(( ${rows[row_index]} - take_num ))
        echo "You take $take_num stone(s) from row $row_num"
        break
    done
}

# function to check if game is over
game_over() {
    local total=0
    for stones in "${rows[@]}"; do
        total=$((total + stones))
    done
    [ $total -eq 1 ]  # game ends when only 1 stone remains
}

# function to get initial game setup
setup_game() {
    echo "Welcome to NIM!"
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
    
    # row setup
    echo "Set up the initial stones for 3 rows (max 18 stones per row, all different):"
    declare -A used_values
    
    for i in {1..3}; do
        while true; do
            read -p "Stones for row $i (1-18): " stones
            
            if [[ ! "$stones" =~ ^[0-9]+$ ]] || [ $stones -lt 1 ] || [ $stones -gt 18 ]; then
                echo "Please enter a number between 1 and 18."
                continue
            fi
            
            if [ ${used_values[$stones]} ]; then
                echo "This number is already used in another row! Choose a different number."
                continue
            fi
            
            used_values[$stones]=1
            rows[$((i-1))]=$stones
            break
        done
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

echo "$current_player will go first!"
}

# main game loop
main() {
    setup_game
    
    while true; do
        display_board
        
        if game_over; then
	    # in normal play, the player who is forced to take the last stone loses
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
        exec "$0"  # Restart the script
    else
        echo "Thanks for playing NIM!"
    fi
}

# start the game
main
```