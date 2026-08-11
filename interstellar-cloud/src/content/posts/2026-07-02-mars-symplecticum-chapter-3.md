---
title: "WUZI QI: From Shadows to Shackles"
pubDatetime: 2026-08-04T00:00:00Z
description: "An exploration of Wuzi Qi, proof-number search, and a complete Bash implementation."
author: "Jerod Michel, Gao Yucheng"
tags: ["bash", "Wuzi Qi", "Gomoku", "game theory", "command line", "math"]
---

<blockquote class="text-right ml-auto max-w-2xl italic mb-8 !border-none !pl-0">
  <p>"The heart of the art of concentration is the planning and conduct<br />of the battle itself. In that area, the commander's aim is to<br />bring together a superior force at the decisive point."</p>
  <p class="font-bold mt-2">— Carl von Clausewitz, On War</p>
</blockquote>

## Description

The board is a 19$\times$19 grid where every stone is a claim on territory and potential. The objective is simple: an unbroken line of five, and the method is a relentless creation of threats. In this game it is not enough merely to react. One must force their opponent to react by building multiple paths to victory simultaneously—forks, only one prong of which can be blocked by an opponent.

Wuzi Qi is won by the player who controls the initiative. The fifth stone is merely the "QED" of a victory secured several moves prior, when control was first siezed.

---

## History

It began in the shadow of Weiqi (Go), some two millennia ago. While scholars contemplated the infinite, the masses played Wuzi Qi on the same board. A simpler pursuit: to get five stones in a row.

It made the journey to Japan around the 7th century, where it became known as Gomoku; the fundamental imbalance, however, did not. For over a thousand years, players complained that whomever moves first has a crushing advantage.

By the 1890s, they could no longer ignore this. Renju—a set of shackles, rules to forbid the most powerful openings, was created in attempt to legislate a balance.

Mathematicians finally confirmed the suspicion in 1992 that, with perfect play, the first player wins. A mathematical inevitability.

## Rules and Gameplay

**Official Rules of Wuzi Qi**

*   **Players:** Two.
*   **Equipment:** A Weiqi (Go) board (19$\times$19 grid) and stones of two colors (traditionally black and white).
*   **Objective:** To be the first player to form an unbroken line of five consecutive stones of their color horizontally, vertically, or diagonally.
*   **Start:** Black plays first, placing one stone on any empty intersection.
*   **Progression:** Players then alternate turns, placing one stone per turn on any empty intersection.
*   **End:** The game ends immediately when one player forms a line of five or more consecutive stones. That player wins.
*   **Note:** Lines of more than five stones (an *overline*) still constitute a win.

## The Mathematics of Wuzi Qi: A Solved Game

In 1993, L. Victor Allis definitively settled a long-standing question in his doctoral thesis *"Searching for Solutions in Games and Artificial Intelligence"*: **with perfect play, the first player (Black) wins Wuzi Qi on a 15$\times$15 board**.

### The Proof Strategy: Proof-Number Search

Allis's proof was computational, relying on a powerful algorithm called **Proof-Number Search (PNS)**. The core idea is to treat the game's state space as an AND/OR tree, which logically models the adversarial nature of the game:

*   **OR nodes**: Positions where it is Black's turn to move. Black wins if *any* available move leads to a win. That is, the position is proven if **Move 1 OR Move 2 OR ... OR Move N** is a winning line.
*   **AND nodes**: Positions where it is White's turn to move. For Black's overall strategy to hold, the position must be a win for Black *only if every single* available White move still leads to a position that is winning for Black. From Black's perspective, this is an AND condition: the position is proven only if **Line 1 AND Line 2 AND ... AND Line N** all remain wins. Conversely, for White, it's an OR node: White wins if *any* of their moves refute Black's winning line.

The algorithm does not search the entire tree, which is astronomically large. Instead, it intelligently selects the most *promising* node to expand next, guided by two numbers:

1.  **Proof Number (pn)**: The minimum number of leaf nodes in the subtree that must be proven to establish the current node as a win for the player to move.
2.  **Disproof Number (dn)**: The minimum number of leaf nodes that must be disproven (shown to be a loss) to establish the current node as a loss for the player to move.

The node with the smallest *pn* (for the attacker) or smallest *dn* (for the defender) is expanded first. This focuses the search on the most critical lines—the easiest paths to prove for the attacker, or the most likely paths to disprove for the defender.

### Key Implications of the Proof

*   **A Theoretical Result:** The proof demonstrates a *forced win* for Black from the empty board. It does not provide a practical strategy for human players, as the winning lines are immensely long and complex.
*   **The End of the "Perfect Game":** For two perfect players, the outcome of Wuzi Qi on a 15$\times$15 board is predetermined. This is why the competitive variant, **Renju**, was created with opening restrictions to re-balance the game.
*   **Computational Complexity:** While Wuzi Qi is a finite game and therefore solvable in principle, the proof shows that its **game tree complexity** is immense, placing it firmly in the class of problems that are intractable for brute-force methods.

Thus, Wuzi Qi stands as a landmark example of a non-trivial game that has been formally solved, marking a significant achievement at the intersection of combinatorial game theory and artificial intelligence.

## Example of Gameplay: The Pivotal Fork

The following sequence demonstrates a critical moment where Black seizes the initiative and creates an unstoppable *double threat*, or *fork*. This occurs when a single move creates two separate winning threats, which the opponent cannot block simultaneously.

![The Pivotal Fork showing a double threat in Wuzi Qi](/wuzi_qi_board.png)

**Position Analysis:**
*   **Open Three:** Horizontal at (1,2)-(2,2)-(3,2). This is one move away from becoming a winning *open four*.
*   **Open Two:** Diagonal at (2,4)-(3,3). While not an immediate threat, it establishes a powerful formation with significant potential.
*   **The Pivotal Point (X):** Position (4,2) is the key intersection. A stone here achieves two critical goals simultaneously:
    *   Completes the open three into a winning **horizontal open four** at (1,2)-(2,2)-(3,2)-(4,2).
    *   Transforms the open two into a formidable **diagonal open three** at (2,4)-(3,3)-(4,2), which itself becomes an immediate winning threat.

**The Fork Move:** Black plays at **(4,2)**:
*   This creates one *immediate* winning threat (the horizontal open four).
*   It also creates a *secondary* winning threat (the new diagonal open three) that must be addressed on the next turn.

White is now in *Zugzwang*—they must address the immediate horizontal open four, but in doing so, they leave the new diagonal open three unblocked, guaranteeing Black a victory on the subsequent move. This is a classic example of using a single stone to create multiple, cascading threats that cannot all be parried.

---

## Play Wuzi Qi in Command Line

This Bash implementation for Wuzi Qi demonstrates how game AI can be built using shell scripting fundamentals. The game employs a 15$\times$15 board with algebraic notation input (A-O for columns, 1-15 for rows) and uses associative arrays for board state management. The AI system follows a layered architecture approach where each difficulty level builds upon the previous, maintaining clean separations of concerns while sharing core game logic such as win detection and move validation. The implementation shows that strategic game AI need not always require higher level language.

These three AI tiers showcase a clear progression in strategyn. The Easy AI operates reactively, focusing on immediate threats and basic positional play--it blocks obvious wins and favors center control but lacks foresight. The Medium AI introduces pattern recognition and threat creation, uses comprehensive threat detection to evaluate both offensive and defensive opportunities, and prioritizes blocking of developing player sequences. The Hard AI posits a still more strategic approach, employing fork detection to create multiple simultaneous threats, enhanced position evaluations, and a stronger analysis of threat potential. Each level maintains reasonable computation time by limiting evaluations to relevant parts of the board and using scoring systems rather than exhaustive searches.

```bash
#!/bin/bash

# Wuzi Qi
# 15x15 board, algebraic notation input

BOARD_SIZE=15
declare -A board
PLAYER_SYMBOL="X"
AI_SYMBOL="O"
EMPTY="."
DIFFICULTY="easy" # default

select_difficulty() {
    echo "Select AI Difficulty Level:"
    echo "1) Easy - Reactive defense, basic strategy"
    echo "2) Medium - Pattern recognition, threat creation"
    echo "3) Hard - Strategic planning, opening theory"
    
    while true; do
        read -p "Enter choice (1-3): " choice
        case $choice in
            1) DIFFICULTY="easy"; break ;;
            2) DIFFICULTY="medium"; break ;;
            3) DIFFICULTY="hard"; break ;;
            *) echo "Invalid choice. Please enter 1, 2, or 3." ;;
        esac
    done
    echo "AI difficulty set to: $DIFFICULTY"
}

# initialize empty board
initialize_board() {
    for ((i=0; i<BOARD_SIZE; i++)); do
        for ((j=0; j<BOARD_SIZE; j++)); do
            board[$i,$j]="$EMPTY"
        done
    done
}

# display the board's coordinates using octal expansion (65 = A, 66 = B, etc)
display_board() {
    echo -n "  "
    for ((i=0; i<BOARD_SIZE; i++)); do
        printf "%2s" $(printf \\$(printf '%03o' $((65+i))))
    done
    echo
    
    for ((i=0; i<BOARD_SIZE; i++)); do
        printf "%2d " $((i+1))
        for ((j=0; j<BOARD_SIZE; j++)); do
            echo -n "${board[$i,$j]} "
        done
        echo
    done
}

# convert algebraic notation to array indices
convert_input() {
    local input=$1
    local col_char=${input:0:1}
    local row_num=${input:1}
    
    # convert column letter to number (A=0, B=1, ...)
    local col=$(( $(printf '%d' "'$col_char") - 65 ))
    local row=$(( row_num - 1 ))
    
    echo "$row $col"
}

# check if a move is valid
is_valid_move() {
    local row=$1
    local col=$2
    
    if (( row < 0 || row >= BOARD_SIZE || col < 0 || col >= BOARD_SIZE )); then
        return 1
    fi
    
    [[ "${board[$row,$col]}" == "$EMPTY" ]]
}

check_win() {
    local symbol=$1
    local directions=("1 0" "0 1" "1 1" "1 -1") # horizontal, vertical, diagonal, anti-diagonal
    
    for ((i=0; i<BOARD_SIZE; i++)); do
        for ((j=0; j<BOARD_SIZE; j++)); do
            if [[ "${board[$i,$j]}" == "$symbol" ]]; then
                for dir in "${directions[@]}"; do
                    local dx=${dir% *}
                    local dy=${dir#* }
                    local count=1
                    
                    # check in positive direction
                    for ((k=1; k<5; k++)); do
                        local ni=$((i + k*dx))
                        local nj=$((j + k*dy))
                        if (( ni >= 0 && ni < BOARD_SIZE && nj >= 0 && nj < BOARD_SIZE )) && 
                           [[ "${board[$ni,$nj]}" == "$symbol" ]]; then
                            ((count++))
                        else
                            break
                        fi
                    done
                    
                    # check in negative direction  
                    for ((k=1; k<5; k++)); do
                        local ni=$((i - k*dx))
                        local nj=$((j - k*dy))
                        if (( ni >= 0 && ni < BOARD_SIZE && nj >= 0 && nj < BOARD_SIZE )) && 
                           [[ "${board[$ni,$nj]}" == "$symbol" ]]; then
                            ((count++))
                        else
                            break
                        fi
                    done
                    
                    if (( count >= 5 )); then
                        return 0
                    fi
                done
            fi
        done
    done
    return 1
}

easy_ai_move() {
    local row col
    local -a winning_moves
    local -a blocking_moves
    local -a good_moves
    local -a ok_moves
    
    echo "AI analyzing board..." >&2
    
    # 1. check if AI can win immediately
    for ((i=0; i<BOARD_SIZE; i++)); do
        for ((j=0; j<BOARD_SIZE; j++)); do
            if [[ "${board[$i,$j]}" == "$EMPTY" ]]; then
                board[$i,$j]="$AI_SYMBOL"
                if check_win "$AI_SYMBOL"; then
                    winning_moves+=("$i $j")
                fi
                board[$i,$j]="$EMPTY"
            fi
        done
    done
    
    if (( ${#winning_moves[@]} > 0 )); then
        local move=${winning_moves[$((RANDOM % ${#winning_moves[@]}))]}
        echo "AI found winning move!" >&2
        echo "$move"
        return
    fi
    
    # 2. check if player can win immediately and block
    for ((i=0; i<BOARD_SIZE; i++)); do
        for ((j=0; j<BOARD_SIZE; j++)); do
            if [[ "${board[$i,$j]}" == "$EMPTY" ]]; then
                board[$i,$j]="$PLAYER_SYMBOL"
                if check_win "$PLAYER_SYMBOL"; then
                    blocking_moves+=("$i $j")
                fi
                board[$i,$j]="$EMPTY"
            fi
        done
    done
    
    if (( ${#blocking_moves[@]} > 0 )); then
        local move=${blocking_moves[$((RANDOM % ${#blocking_moves[@]}))]}
        echo "AI blocking win threat!" >&2
        echo "$move"
        return
    fi
    
    # 3. detect and block developing player lines (2+ stones in a row)
    for ((i=0; i<BOARD_SIZE; i++)); do
        for ((j=0; j<BOARD_SIZE; j++)); do
            if [[ "${board[$i,$j]}" == "$EMPTY" ]]; then
                local defensive_score=0
                
                # check all directions for player stones
                for dir in "1 0" "0 1" "1 1" "1 -1"; do
                    local dx=${dir% *}
                    local dy=${dir#* }
                    local player_count=0
                    
                    # check both directions
                    for ((k=-4; k<=4; k++)); do
                        if (( k == 0 )); then continue; fi
                        local ni=$((i + k*dx))
                        local nj=$((j + k*dy))
                        if (( ni >= 0 && ni < BOARD_SIZE && nj >= 0 && nj < BOARD_SIZE )) && 
                           [[ "${board[$ni,$nj]}" == "$PLAYER_SYMBOL" ]]; then
                            ((player_count++))
                        fi
                    done
                    
                    # higher score for longer player sequences
                    if (( player_count >= 2 )); then
                        ((defensive_score += player_count * 4))
                    fi
                done
                
                if (( defensive_score > 0 )); then
                    # this is a good defensive move
                    good_moves+=("$i $j:$defensive_score")
                fi
            fi
        done
    done
    
    # 4. if we found defensive moves, use the best one
    if (( ${#good_moves[@]} > 0 )); then
        # find the move with highest defensive score
        local best_move=""
        local best_score=0
        for move_info in "${good_moves[@]}"; do
            local move=${move_info%:*}
            local score=${move_info#*:}
            if (( score > best_score )); then
                best_score=$score
                best_move=$move
            fi
        done
        echo "AI making defensive move (score: $best_score)!" >&2
        echo "$best_move"
        return
    fi
    
    # 5. look for strategic positions (near center and existing stones)
    local center=$((BOARD_SIZE / 2))
    
    for ((i=0; i<BOARD_SIZE; i++)); do
        for ((j=0; j<BOARD_SIZE; j++)); do
            if [[ "${board[$i,$j]}" == "$EMPTY" ]]; then
                local score=0
                
                # score based on distance from center (prefer center)
                local dist_from_center=$(( (i - center)**2 + (j - center)**2 ))
                if (( dist_from_center <= 2 )); then
                    ((score += 10))
                elif (( dist_from_center <= 8 )); then
                    ((score += 5))
                fi
                
                # score based on proximity to AI stones
                local ai_neighbors=0
                for ((dx=-2; dx<=2; dx++)); do
                    for ((dy=-2; dy<=2; dy++)); do
                        if (( dx == 0 && dy == 0 )); then continue; fi
                        local ni=$((i + dx))
                        local nj=$((j + dy))
                        if (( ni >= 0 && ni < BOARD_SIZE && nj >= 0 && nj < BOARD_SIZE )) && 
                           [[ "${board[$ni,$nj]}" == "$AI_SYMBOL" ]]; then
                            ((ai_neighbors++))
                        fi
                    done
                done
                ((score += ai_neighbors * 3))
                
                # categorize moves by score
                if (( score >= 8 )); then
                    ok_moves+=("$i $j")
                fi
            fi
        done
    done
    
    # 6. use strategic moves if available
    if (( ${#ok_moves[@]} > 0 )); then
        local move=${ok_moves[$((RANDOM % ${#ok_moves[@]}))]}
        echo "AI making strategic move!" >&2
        echo "$move"
        return
    fi
    
    # 7. final fallback: random but not completely stupid
    local -a random_moves
    for ((i=0; i<BOARD_SIZE; i++)); do
        for ((j=0; j<BOARD_SIZE; j++)); do
            if [[ "${board[$i,$j]}" == "$EMPTY" ]]; then
                # Prefer positions not in the very corners
                if (( i > 0 && i < BOARD_SIZE-1 && j > 0 && j < BOARD_SIZE-1 )); then
                    random_moves+=("$i $j")
                fi
            fi
        done
    done
    
    if (( ${#random_moves[@]} > 0 )); then
        local move=${random_moves[$((RANDOM % ${#random_moves[@]}))]}
        echo "AI making random move!" >&2
        echo "$move"
        return
    fi
    
    # 8. absolute last resort: any empty spot
    while true; do
        row=$(( RANDOM % BOARD_SIZE ))
        col=$(( RANDOM % BOARD_SIZE ))
        if is_valid_move $row $col; then
            echo "AI making desperate move!" >&2
            echo "$row $col"
            return
        fi
    done
}

# check sequence length in a given direction
check_sequence_length() {
    local symbol=$1
    local row=$2
    local col=$3
    local dx=$4
    local dy=$5
    local count=1  # count the current position
    
    # check positive direction
    for ((k=1; k<=4; k++)); do
        local ni=$((row + k*dx))
        local nj=$((col + k*dy))
        if (( ni >= 0 && ni < BOARD_SIZE && nj >= 0 && nj < BOARD_SIZE )) && 
           [[ "${board[$ni,$nj]}" == "$symbol" ]]; then
            ((count++))
        else
            break
        fi
    done
    
    # check negative direction
    for ((k=1; k<=4; k++)); do
        local ni=$((row - k*dx))
        local nj=$((col - k*dy))
        if (( ni >= 0 && ni < BOARD_SIZE && nj >= 0 && nj < BOARD_SIZE )) && 
           [[ "${board[$ni,$nj]}" == "$symbol" ]]; then
            ((count++))
        else
            break
        fi
    done
    
    echo $count
}

# count open ends of a sequence
count_open_ends() {
    local symbol=$1
    local row=$2  
    local col=$3
    local dx=$4
    local dy=$5
    local open_ends=0
    
    # check positive direction
    local forward_steps=1
    while true; do
        local ni=$((row + forward_steps*dx))
        local nj=$((col + forward_steps*dy))
        if (( ni >= 0 && ni < BOARD_SIZE && nj >= 0 && nj < BOARD_SIZE )); then
            if [[ "${board[$ni,$nj]}" == "$symbol" ]]; then
                ((forward_steps++))
                continue
            elif [[ "${board[$ni,$nj]}" == "$EMPTY" ]]; then
                ((open_ends++))
                break
            else
                break
            fi
        else
            break
        fi
    done
    
    # check negative direction  
    local backward_steps=1
    while true; do
        local ni=$((row - backward_steps*dx))
        local nj=$((col - backward_steps*dy))
        if (( ni >= 0 && ni < BOARD_SIZE && nj >= 0 && nj < BOARD_SIZE )); then
            if [[ "${board[$ni,$nj]}" == "$symbol" ]]; then
                ((backward_steps++))
                continue
            elif [[ "${board[$ni,$nj]}" == "$EMPTY" ]]; then
                ((open_ends++))
                break
            else
                break
            fi
        else
            break
        fi
    done
    
    echo $open_ends
}

# enhanced comprehensive threat detection
detect_comprehensive_threats() {
    local symbol=$1
    local row=$2
    local col=$3
    local threat_score=0
    
    # check ALL directions for threats
    local directions=("1 0" "0 1" "1 1" "1 -1")
    
    for dir in "${directions[@]}"; do
        local dx=${dir% *}
        local dy=${dir#* }
        local sequence_length=$(check_sequence_length "$symbol" "$row" "$col" "$dx" "$dy")
        
        if (( sequence_length >= 2 )); then
            # much higher score for longer sequences
            local sequence_score=$((sequence_length * sequence_length * 3))
            ((threat_score += sequence_score))
            
            # count open ends - sequences with open ends are more dangerous
            local open_ends=$(count_open_ends "$symbol" "$row" "$col" "$dx" "$dy")
            if (( open_ends >= 1 )); then
                ((threat_score += open_ends * 8))
                
                # critical threat: 4 stones with an open end
                if (( sequence_length >= 4 )); then
                    ((threat_score += 50)) # Near-winning threat!
                elif (( sequence_length >= 3 && open_ends >= 2 )); then
                    ((threat_score += 30)) # Open three - very dangerous
                fi
            fi
        fi
    done
    
    echo $threat_score
}

# MEDIUM AI: Pattern recognition and threat creation
medium_ai_move() {
    local row col
    local -a winning_moves
    local -a blocking_moves
    local -a good_moves
    local -a ok_moves
    
    echo "Medium AI analyzing patterns..." >&2
    
    # 1. check if AI can win immediately (same as easy)
    for ((i=0; i<BOARD_SIZE; i++)); do
        for ((j=0; j<BOARD_SIZE; j++)); do
            if [[ "${board[$i,$j]}" == "$EMPTY" ]]; then
                board[$i,$j]="$AI_SYMBOL"
                if check_win "$AI_SYMBOL"; then
                    winning_moves+=("$i $j")
                fi
                board[$i,$j]="$EMPTY"
            fi
        done
    done
    
    if (( ${#winning_moves[@]} > 0 )); then
        local move=${winning_moves[$((RANDOM % ${#winning_moves[@]}))]}
        echo "AI found winning move!" >&2
        echo "$move"
        return
    fi
    
    # 2. check if player can win immediately (same as easy)
    for ((i=0; i<BOARD_SIZE; i++)); do
        for ((j=0; j<BOARD_SIZE; j++)); do
            if [[ "${board[$i,$j]}" == "$EMPTY" ]]; then
                board[$i,$j]="$PLAYER_SYMBOL"
                if check_win "$PLAYER_SYMBOL"; then
                    blocking_moves+=("$i $j")
                fi
                board[$i,$j]="$EMPTY"
            fi
        done
    done
    
    if (( ${#blocking_moves[@]} > 0 )); then
        local move=${blocking_moves[$((RANDOM % ${#blocking_moves[@]}))]}
        echo "AI blocking win threat!" >&2
        echo "$move"
        return
    fi
    
    # 3. MEDIUM ENHANCEMENT: Detect and create open threes
    for ((i=0; i<BOARD_SIZE; i++)); do
        for ((j=0; j<BOARD_SIZE; j++)); do
            if [[ "${board[$i,$j]}" == "$EMPTY" ]]; then
                local defensive_score=0
                local offensive_score=0
                
                # check what threats this position would create for PLAYER (defensive)
                board[$i,$j]="$PLAYER_SYMBOL"
                defensive_score=$(detect_comprehensive_threats "$PLAYER_SYMBOL" "$i" "$j")
                board[$i,$j]="$EMPTY"
                
                # check what threats this position would create for AI (offensive)  
                board[$i,$j]="$AI_SYMBOL"
                offensive_score=$(detect_comprehensive_threats "$AI_SYMBOL" "$i" "$j")
                board[$i,$j]="$EMPTY"
                
                # combine scores with priority on defense
                local total_score=$((defensive_score * 2 + offensive_score))
                
                if (( total_score >= 40 )); then
                    # critical threat - near winning move
                    good_moves+=("$i $j:$total_score")
                elif (( total_score >= 20 )); then
                    # strong threat
                    good_moves+=("$i $j:$total_score")
                elif (( total_score >= 10 )); then
                    ok_moves+=("$i $j:$total_score")
                fi
            fi
        done
    done
    
    # 4. use best defensive/offensive moves
    if (( ${#good_moves[@]} > 0 )); then
        local best_move=""
        local best_score=0
        for move_info in "${good_moves[@]}"; do
            local move=${move_info%:*}
            local score=${move_info#*:}
            if (( score > best_score )); then
                best_score=$score
                best_move=$move
            fi
        done
        echo "AI making tactical move (score: $best_score)!" >&2
        echo "$best_move"
        return
    fi
    
    # 5. fall back to easy AI logic for basic strategy
    echo "Falling back to basic strategy..." >&2
    easy_ai_move
}

# HARD AI: practical threat detection
hard_ai_move() {
    local row col
    local -a winning_moves
    local -a blocking_moves
    local -a strategic_moves
    local -a good_moves
    
    echo "Hard AI: Advanced threat analysis..." >&2
    
    # 1. check if AI can win immediately
    for ((i=0; i<BOARD_SIZE; i++)); do
        for ((j=0; j<BOARD_SIZE; j++)); do
            if [[ "${board[$i,$j]}" == "$EMPTY" ]]; then
                board[$i,$j]="$AI_SYMBOL"
                if check_win "$AI_SYMBOL"; then
                    winning_moves+=("$i $j")
                fi
                board[$i,$j]="$EMPTY"
            fi
        done
    done
    
    if (( ${#winning_moves[@]} > 0 )); then
        local move=${winning_moves[$((RANDOM % ${#winning_moves[@]}))]}
        echo "AI found winning move!" >&2
        echo "$move"
        return
    fi
    
    # 2. check if player can win immediately
    for ((i=0; i<BOARD_SIZE; i++)); do
        for ((j=0; j<BOARD_SIZE; j++)); do
            if [[ "${board[$i,$j]}" == "$EMPTY" ]]; then
                board[$i,$j]="$PLAYER_SYMBOL"
                if check_win "$PLAYER_SYMBOL"; then
                    blocking_moves+=("$i $j")
                fi
                board[$i,$j]="$EMPTY"
            fi
        done
    done
    
    if (( ${#blocking_moves[@]} > 0 )); then
        local move=${blocking_moves[$((RANDOM % ${#blocking_moves[@]}))]}
        echo "AI blocking win threat!" >&2
        echo "$move"
        return
    fi
    
    # 3. HARD IMPROVEMENT: enhanced threat detection using simple pattern matching
    for ((i=0; i<BOARD_SIZE; i++)); do
        for ((j=0; j<BOARD_SIZE; j++)); do
            if [[ "${board[$i,$j]}" == "$EMPTY" ]]; then
                local score=0
                
                # check what AI threats this move creates
                board[$i,$j]="$AI_SYMBOL"
                score=$((score + $(evaluate_position "$AI_SYMBOL")))
                board[$i,$j]="$EMPTY"
                
                # check what player threats this move blocks (higher weight)
                board[$i,$j]="$PLAYER_SYMBOL"
                score=$((score + $(evaluate_position "$PLAYER_SYMBOL") * 2))
                board[$i,$j]="$EMPTY"
                
                # position value - prefer center and connections to existing stones
                local center=$((BOARD_SIZE / 2))
                local dist_from_center=$(( (i - center)**2 + (j - center)**2 ))
                local position_bonus=$((20 - dist_from_center))
                if (( position_bonus < 0 )); then
                    position_bonus=0
                fi
                score=$((score + position_bonus))
                
                # connection bonus to existing AI stones
                local connection_bonus=0
                for ((dx=-1; dx<=1; dx++)); do
                    for ((dy=-1; dy<=1; dy++)); do
                        if (( dx == 0 && dy == 0 )); then continue; fi
                        local ni=$((i + dx))
                        local nj=$((j + dy))
                        if (( ni >= 0 && ni < BOARD_SIZE && nj >= 0 && nj < BOARD_SIZE )); then
                            if [[ "${board[$ni,$nj]}" == "$AI_SYMBOL" ]]; then
                                ((connection_bonus += 5))
                            fi
                        fi
                    done
                done
                score=$((score + connection_bonus))
                
                if (( score >= 100 )); then
                    strategic_moves+=("$i $j:$score")
                elif (( score >= 50 )); then
                    good_moves+=("$i $j:$score")
                fi
            fi
        done
    done
    
    # 4. look for fork opportunities (moves that create multiple threats)
    for ((i=0; i<BOARD_SIZE; i++)); do
        for ((j=0; j<BOARD_SIZE; j++)); do
            if [[ "${board[$i,$j]}" == "$EMPTY" ]]; then
                local threat_count=0
                
                board[$i,$j]="$AI_SYMBOL"
                
                # count how many directions have at least 3 in a row with open ends
                for dir in "1 0" "0 1" "1 1" "1 -1"; do
                    local dx=${dir% *}
                    local dy=${dir#* }
                    local seq_len=$(check_sequence_length "$AI_SYMBOL" "$i" "$j" "$dx" "$dy")
                    local open_ends=$(count_open_ends "$AI_SYMBOL" "$i" "$j" "$dx" "$dy")
                    
                    if (( seq_len >= 3 && open_ends >= 1 )); then
                        ((threat_count++))
                    fi
                done
                
                board[$i,$j]="$EMPTY"
                
                if (( threat_count >= 2 )); then
                    # This is a fork move - very powerful!
                    echo "AI found fork opportunity with $threat_count threats!" >&2
                    echo "$i $j"
                    return
                fi
            fi
        done
    done
    
    # 5. use strategic moves
    if (( ${#strategic_moves[@]} > 0 )); then
        local best_move=""
        local best_score=0
        for move_info in "${strategic_moves[@]}"; do
            local move=${move_info%:*}
            local score=${move_info#*:}
            if (( score > best_score )); then
                best_score=$score
                best_move=$move
            fi
        done
        echo "AI making strategic move (score: $best_score)!" >&2
        echo "$best_move"
        return
    fi
    
    # 6. use good moves
    if (( ${#good_moves[@]} > 0 )); then
        local best_move=""
        local best_score=0
        for move_info in "${good_moves[@]}"; do
            local move=${move_info%:*}
            local score=${move_info#*:}
            if (( score > best_score )); then
                best_score=$score
                best_move=$move
            fi
        done
        echo "AI making good move (score: $best_score)!" >&2
        echo "$best_move"
        return
    fi
    
    # 7. final fallback: medium AI (which works reasonably)
    echo "Hard AI using medium fallback..." >&2
    medium_ai_move
}

# simple position evaluation
evaluate_position() {
    local symbol=$1
    local score=0
    
    # check all directions for sequences
    for ((i=0; i<BOARD_SIZE; i++)); do
        for ((j=0; j<BOARD_SIZE; j++)); do
            if [[ "${board[$i,$j]}" == "$symbol" ]]; then
                for dir in "1 0" "0 1" "1 1" "1 -1"; do
                    local dx=${dir% *}
                    local dy=${dir#* }
                    
                    # check consecutive stones
                    local count=1
                    for ((k=1; k<5; k++)); do
                        local ni=$((i + k*dx))
                        local nj=$((j + k*dy))
                        if (( ni >= 0 && ni < BOARD_SIZE && nj >= 0 && nj < BOARD_SIZE )) && 
                           [[ "${board[$ni,$nj]}" == "$symbol" ]]; then
                            ((count++))
                        else
                            break
                        fi
                    done
                    
                    # score sequences appropriately
                    case $count in
                        2) ((score += 5)) ;;
                        3) ((score += 20)) ;;
                        4) ((score += 100)) ;;
                        5) ((score += 1000)) ;;
                    esac
                done
            fi
        done
    done
    
    echo $score
}

# AI dispatcher
ai_move() {
    case $DIFFICULTY in
        "easy") easy_ai_move ;;
        "medium") medium_ai_move ;;
        "hard") hard_ai_move ;;
        *) easy_ai_move ;; # fallback
    esac
}

# Main game loop
main() {
    initialize_board
    echo "Welcome to Wuzi Qi (Gomoku)!"
    echo "Enter moves as column letter + row number (e.g., H8 for center)"
    select_difficulty
    
    while true; do
        display_board
        
        # Player's turn
        while true; do
            read -p "Your move (e.g., H8): " player_input
            if [[ ! "$player_input" =~ ^[A-O][1-9][0-5]?$ ]]; then
                echo "Invalid format. Use letter A-O and number 1-15 (e.g., H8)"
                continue
            fi
            
            read row col <<< $(convert_input "$player_input")
            if is_valid_move $row $col; then
                board[$row,$col]="$PLAYER_SYMBOL"
                break
            else
                echo "Invalid move! That spot is taken or out of bounds."
            fi
        done
        
        # check if player won
        if check_win "$PLAYER_SYMBOL"; then
            display_board
            echo "Congratulations! You won!"
            break
        fi
        
        # AI's turn
        echo "AI is thinking..."
        sleep 1
        read ai_row ai_col <<< $(ai_move)
        board[$ai_row,$ai_col]="$AI_SYMBOL"

        # convert AI move back to algebraic for display
        local ai_col_char=$(printf \\$(printf '%03o' $((65 + ai_col))))
        local ai_row_num=$((ai_row + 1))
        echo "AI plays: $ai_col_char$ai_row_num"

        display_board
        
        # check if AI won
        if check_win "$AI_SYMBOL"; then
            display_board
            echo "AI wins! Better luck next time."
            break
        fi
    done
}

# start the game
main
```

---

**References:**
* Allis, L. Victor. (1994). Searching for Solutions in Games and Artificial Intelligence. [Doctoral Thesis, Maastricht University].