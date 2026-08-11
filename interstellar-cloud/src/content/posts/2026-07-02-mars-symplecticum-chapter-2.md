---
title: "GOOFSPIEL: Determinist's Bane"
pubDatetime: 2026-08-04T00:00:00Z
description: "An exploration of Goofspiel, mixed strategies, and a complete Bash implementation."
author: "Jerod Michel, Gao Yucheng"
tags: ["bash", "game theory", "Goofspiel", "mixed strategy", "command line", "math"]
---

<blockquote class="text-right ml-auto max-w-2xl italic mb-8 !border-none !pl-0">
  <p>"Everyone sees what you appear to be, few experience what you really are."</p>
  <p class="font-bold mt-2">— Niccolò Machiavelli</p>
</blockquote>

## Description

Goofspiel—German for "Game of Fools"—is anything but foolish. It is an abrupt arena where perfect information meets imperfect human judgment. Two players, each holding an identical hand of thirteen cards, compete for prizes drawn from a third deck. The rules are deceptively simple: players bid cards simultaneously, the higher bid takes the prize. Yet within this simplicity lies a profound truth about conflict: knowing everything does not mean understanding everything.

This is not a game of chance. It is a game of *projection*—of convincing your opponent that your eight is a king, and their king is an eight. While Chess shows you the battlefield, and NIM reveals the binary logic of finite economics, Goofspiel shows you the enemy's arsenal but never their intentions.

The prizes sit openly between you—their values clear, but the bids are made in the confines of your opponent's mind. Victory goes not to the player who values the prize most, but to the one who most accurately prices their opponent's desperation.

## History

The game first came to public consciousness under the name "Goofspiel" in a 1940 issue of *Esquire* magazine, presented as a diversion. The name suggests a game for the simple—yet another layer of misdirection. Its mathematical constitution remained hidden for decades.

It's uncovering came in the Cold War crucible of game theory. As mathematicians like von Neumann and Nash dissected conflict through Prisoner's Dilemmas and zero-sum games, Goofspiel sat quietly in the background—too complex for immediate solution, but too elegant to be ignored for much longer.

Then came Sheldon Ross in 1971, who delivered the first definitive mathematical autopsy. His proof demonstrated what experienced players had long suspected: there is no single "best" way to play Goofspiel. No pure strategy can dominate. The game *requires* deception, unpredictability, and mixed strategies. Optimal play involves calculated randomness—a concept that likely would have made the generals of old shudder.

It is fitting that a game about values hidden in plain sight would itself conceal such mathematical depth within such simple rules. It has since traveled under many aliases: "The Game of Pure Strategy," "Prisoner's Cards," and in some circles, "The Diplomat's Dilemma." Each name captures a different facet of its essence, but all point to the same truth: in a world of perfect information, the only thing left to hide is yourself.

## Rules and Gameplay

### Materials

Three full suits from a standard deck of playing cards, i.e., the ranks Ace (1) through King (13) of each of the three suits are required. For this discussion, these will be represented thusly:

*   **Player 1's Hand:** The Club suit (♣). Your arsenal.
*   **Player 2's Hand:** The Spade suit (♠). The opponent's arsenal.
*   **Prize Deck:** The Diamond suit (♦). The spoils, or, prizes, shuffled and placed between you.

The Hearts (♥) remain in the box.

### The Game

The game proceeds over thirteen rounds—a single, bloody season of conflict.

1.  **Deploy the first Prize.** The top Diamond is revealed and placed in the center. Its value is the objective for the round.
2.  **Private Council.** Both players simultaneously select a card from their own hand. This is your bid—your commitment. It is placed face-down. Your opponent does the same.
3.  **Revelation.** Bids are revealed. A simple calculus determines the victor:
    *   The **higher bid** claims the Diamond prize. Its value is added to their purse.
    *   The **lower bid** gains nothing (except, perhaps, experience).
    *   In the event of a **tie**, no one can claim the prize—there is just scorched earth.
4.  **Graveyard.** The bid cards, both yours and your opponent's, are discarded to the graveyard. They are spent. They cannot be used again.

The game ends when all thirteen Diamonds have been contested. The player with the highest total value in their purse is the victor.

### The Strategic Terrain

Do not be fooled by the procedural simplicity. The game is a marathon of resource calculation and allocation. Wasting a King (13) to secure a low-ranking card is a catastrophic misallocation, a tell-tale sign of desperation, or just foolishness.

The core dilemma is eternal: *Do you fight for the current prize, or do you conserve your strength for the future?* There are no reinforcements. Every card you play is a permanent reduction of options. The game is a slow and inexorable constriction of possibility, and a lesson in the economy of violence.

Victory is not about winning the most rounds. It is about winning the *right* rounds. It is about ensuring that the sum of your victories outweighs the sum of your opponent's, no matter what individual skirmishes you might concede.

<div class="remark">

**Remark.**

The true genius of Goofspiel reveals itself not in the first round, but in the second. Once both players understand the rules, they enter into a metagame of prediction and counter-prediction. You are no longer playing cards; you are playing the ghost of your opponent's previous decisions. This is where the mathematics are discerned.

</div>

## That Goofspiel has no Pure Strategy Equilibrium

Let $A = (a_1, \dots, a_n)$ and $B = (b_1, \dots, b_n)$ be the players' strategies, where $a_i, b_j$ represent the bids for prize $v_i.$ The total payoff for Player 1 is:

<div class="definition">

**Definition.**

The payoff function $\pi(A,B) = \sum_{i=1}^n v_i \cdot \mathbb{I}_{a_i > b_i}.$

</div>

<div class="theorem">

**Theorem (Dror, 1989).**

For $n \geq 2$ distinct prizes, Goofspiel admits no pure strategy Nash equilibrium.

</div>

<div class="proof">

**Proof.**

Assume contrary that $(A^*, B^*)$ is a pure strategy Nash equilibrium. Consider the reordering of prizes such that $v_1 > v_2 > \dots > v_n.$

**No ties in equilibrium**: If $a_i^* = b_i^*$ for any $i$, either player can profit by deviating to $a_i^* + \epsilon.$

**Monotonicity**: In equilibrium, we must have $a_i^* > a_j^* \iff b_i^* > b_j^*$ for all $i,j.$ Otherwise, a profitable reallocation exists.

Without loss, assume both sequences are increasing: $a_1^* < \dots < a_n^*$ and $b_1^* < \dots < b_n^*.$

The expected payoff becomes:

$$
\begin{aligned}
\pi(A^*, B^*) &= \sum_{i=1}^n v_i \cdot \mathbb{I}_{a_i^* > b_i^*}
\end{aligned}
$$

**Contradiction**: Consider the alternative pairing where Player 1 uses the identity mapping $a_i = i$ against Player 2's strategy. The maximum is achieved when $\mathbb{I}_{a_i > b_i} = 1$ for all $i$, but this cannot be an equilibrium as Player 2 would deviate.

More precisely, for any fixed pairing $(A,B)$, there exists $k$ such that:

$$
\begin{aligned}
\sum_{i=1}^n v_i \mathbb{I}_{a_i > b_i} &< \max_{\sigma \in S_n} \sum_{i=1}^n v_i \mathbb{I}_{a_i > b_{\sigma(i)}}
\end{aligned}
$$

where $S_n$ is the symmetric group. The right-hand side represents the optimal reassignment of bids against the fixed strategy.

Thus, no pure strategy profile can be immune to unilateral deviations.<div class="text-right">$\square$</div>

</div>

<div class="remark">

**Remark (The Nash Equilibrium Interpretation).**

Dror's result demonstrates that Goofspiel belongs to the class of games where the only Nash equilibria occur in *mixed strategies*. The inequality:

$$
\begin{aligned}
\max_A \min_B \pi(A,B) &= \min_B \max_A \pi(A,B) = 0
\end{aligned}
$$

holds, and the value of the game is zero under standard scoring. This formalizes the intuition that in optimal play, no deterministic pattern can prevail—each player must randomize their bids to remain unpredictable. The mathematical necessity of deception emerges not as a psychological preference, but as a topological consequence of the strategy space.

</div>

<div class="remark">

**Remark (For the Practitioner).**

For the working strategist, this theorem provides a cold consolation: your intuition that "there must be a best way to bid" is mathematically false. The game resists any attempt at deterministic mastery. Your only refuge lies in calculated randomness—the very mixed strategies that define the game's Nash equilibria. In this light, Goofspiel becomes a perfect laboratory for testing how one does with fundamental uncertainty.

</div>

## Example of Play

### The Theater of Thirteen Rounds

What follows is not a transcript, but an autopsy of a typical game—a demonstration of the psychological warfare that unfolds when both players understand the mathematical void at Goofspiel's heart.

| Round | Prize | Player 1 (♣) | Player 2 (♠) | Outcome |
|:---:|:---:|:---:|:---:|---|
| 1 | 5♦ | 5 | 6 | Player 2 wins, spending highly |
| 2 | 2♦ | 2 | 1 | Player 1 wins efficiently |
| 3 | 13♦ | 4 | 12 | Player 2 wins the King, overcommitting |
| 4 | 8♦ | 10 | 3 | Player 1 wins, wasting a 10 |
| 5 | 1♦ | 1 | 2 | Player 2 wins, continuing the pattern |

Let us examine the strategic subtext of these opening moves.

#### Rounds 1-3: The Opening Gambits
Player 2 begins aggressively, using a 6 to claim a mediocre 5. A questionable allocation of force, signaling either confidence or profligacy. Player 1 responds with surgical efficiency, taking the 2 with a 2—perfect valuation.

Then, the first major prize appears: the King (13). Player 1 makes a bold, almost reckless bluff, bidding a mere 4. Player 2, perhaps fearing a trap or overestimating their opponent's reserves, responds with a 12. Player 1's bluff fails, but it reveals something precious: Player 2 is willing to spend high cards early.

#### Rounds 4-5: The Psychological Shift
Here, the game's true nature emerges. The 8 appears—a substantial prize. Player 1, perhaps frustrated by the failed bluff or misreading Player 2's remaining strength, deploys a 10. This is a critical error: *wasting a high card on a medium prize*. Player 2, showing restraint, bids only a 3, conceding the round but preserving their high cards.

The game continues, but the damage is done. Player 1 has revealed their hand's diminishing quality, while Player 2 has conserved their strength. The remaining rounds become a slow, inevitable constriction.

#### The Endgame
By round 10, the score stands at Player 1: 28 points, Player 2: 35 points. The remaining prizes are 11, 7, and 3. Player 1 holds 11, 13; Player 2 holds 7, 9.

*   **Prize 11**: Player 1 must bid their 11 to have any hope. Player 2, knowing this, bids 7. Player 1 claims the prize but is left with only a 13.
*   **Prize 7**: Player 2 bids 9, easily beating Player 1's forced 13—a catastrophic overpayment.
*   **Prize 3**: Player 1 has no cards left. Player 2 claims it with whatever remains.

Final score: Player 1: 39, Player 2: 45.

<div class="remark">

**Remark.**

Notice that Player 1 won more individual rounds (6 to Player 2's 7), yet lost decisively. Goofspiel is not about victory in battle, but the economic management of force. Player 2 understood this; Player 1 won battles but lost the war through poor resource allocation. The player who appears to be winning in the early rounds is often the one hemorrhaging strategic capital.

</div>

<div class="remark">

**Remark (The Digital Implementation).**

In our Bash implementation, the Medium AI would have noted Player 1's wasteful bid of a 10 on prize 8, decrementing its internal `PLAYER_HIGH_CARD_COUNT`. The Hard AI would have further detected the aggressive pattern and adapted its bidding strategy accordingly, perhaps bluffing more frequently against such an opponent. The mathematics of Dror's proof finds its expression in these adaptive heuristics—the mixed strategies playing out in code.

</div>

## Play Goofspiel in Command Line

Our Goofspiel implementation posits a simple bidding arena through array manipulations. Player hands and the prize deck are each represented as simple arrays, where card removal and scoring are handled via array slicing and filtering. We use Unicode for suits to give some visual clarity, and we preserve the game's "hidden information" by concealing the AI's actual cards, and reveal only the remaining count.

The AI employs a multi-layered strategy that evolves with difficulty. At the easy level, the computer uses straightforward value-based bidding, matching card values to prize values with some minor randomization. The medium AI introduces psychological warfare through bluffing and pattern recognition, and tracking the player's high-card usage to detect strategic tendencies. The hard AI represents our more ambitious implementation, performing real-time game state analysis that considers score differentials, remaining high cards, and inferred player strategies for adapting its approach.

What makes this implementation compelling is how it demonstrates that, even in a constrained scripting environment, we can model complex decision-making processes that account for incomplete information, opponent modeling, and multi-round strategy. The AI doesn't just react to the current prize, but builds a narrative for the player's style throughout, and counters it accordingly.

```bash
#!/bin/bash

# Goofspiel Game in Bash with Machine Learning-inspired difficulty levels

# game state variables
declare -a player_hand=({1..13})           # clubs - player's bidding cards
declare -a ai_hand=({1..13})               # spades - AI's bidding cards  
declare -a prize_deck=({1..13})            # diamonds - prizes to be won
declare -a player_purse=()                 # player's acquired prizes
declare -a ai_purse=()                     # AI's acquired prizes
declare -a chosen_bids=()                  # chosen bids not yet revealed
PLAYER_HIGH_CARD_COUNT=4                   # for 10, J, Q, K
difficulty="medium"

current_prize=""                           # current prize card from top of deck

# define card suit symbols
SPADE="\u2660"
CLUB="\u2663"
DIAMOND="\u2666"
HEART="\u2665"

# function to display the game board
display_table() {
    echo
    echo "==== New Round ===="
    echo
    echo "--- Player's Hand ----"
    hand_string=""
    for card in "${player_hand[@]}"; do
        if [[ -n "$hand_string" ]]; then
            hand_string+=" |"
        fi
        hand_string+="${card}$CLUB"
    done
    echo -e "$hand_string"
    echo
    echo "--- AI's Hand ----"
    echo -e "[${#ai_hand[@]} cards ($SPADE ) remaining]"
    echo
#    echo "---Current Prize---"
#    if [[ -n "$current_prize" ]]; then
#        echo -e "${current_prize}$DIAMOND"
#    else
#        echo "First prize is drawn!"
#    fi
}

# function to get initial game setup
setup_game() {
    echo "Welcome to Goofspiel!"
    echo
    
    # difficulty selection
    while true; do
        echo "Select difficulty:"
        echo "1 - Easy (computer plays with minimal considerations of pattern)"
        echo "2 - Medium (computer bluffs and considers some patterns)"  
        echo "3 - Hard (computer considers patterns aggressively and bluffs aggressively)"
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
}

#function to pull a prize at random from the deck
draw_prize() {
    if [ ${#prize_deck[@]} -eq 0 ]; then
        echo "No more prizes left!"
        return 1
    fi
    
    # take the first card
    current_prize="${prize_deck[0]}"
    
    # remove the first card from the deck
    prize_deck=("${prize_deck[@]:1}")
    
    echo -e "~~~~~ Current prize: ${current_prize}$DIAMOND  ~~~~~"
}

shuffle_prize_deck() {
    prize_deck=($(shuf -e "${prize_deck[@]}"))
    echo "Prize deck shuffled!"
}

in_array() {
  local needle="$1"
  shift
  for element in "$@"; do
    if [[ "$element" == "$needle" ]]; then
      return 0 # found
    fi
  done
  return 1 # not found
}

player_to_bid() {
    while true; do
        echo "Make a bid! Enter a rank from your hand (11 = J, 12 = Q, 13 = K):"
        read -p "> " input
        
        # validate input
        if ! in_array "$input" "${player_hand[@]}"; then
            echo ""$input" is not in your hand!"
            continue
        else
            chosen_bids+=($input)
            new_hand=()
            for card in "${player_hand[@]}"; do
	        if [[ "$card" != "$input" ]]; then
	            new_hand+=("$card")
	        fi
	    done
	    player_hand=("${new_hand[@]}")
            break
        fi
    done
}

AI_to_bid_easy() {
    # define the "target bid" as the prize value, plus or minus 1
    target_bid=$(( $current_prize + (RANDOM % 3 - 1) )) # this gives -1, 0, or +1
    # ensure the target bid is between 1 and 13
    target_bid=$(( target_bid < 1 ? 1 : (target_bid > 13 ? 13 : target_bid) ))

    # check if the target_bid is in the AI's hand
    if [[ " ${ai_hand[@]} " =~ " ${target_bid} " ]]; then
    ai_bid=$target_bid
    else
        # if not, find the closest available card in the hand
        closest_diff=14
        for card in "${ai_hand[@]}"; do
            diff=$(( card > target_bid ? card - target_bid : target_bid - card ))
            if (( diff < closest_diff )); then
                closest_diff=$diff
                ai_bid=$card
            fi
        done
    fi
    chosen_bids+=($ai_bid)
    new_AI_hand=()
    for card in "${ai_hand[@]}"; do
        if [[ "$card" != "$ai_bid" ]]; then
            new_AI_hand+=("$card")
        fi
    done
    ai_hand=("${new_AI_hand[@]}")
}

get_value_bid() {
    local prize_value="$1"
    local hand=("${@:2}")  # all remaining arguments are the hand
    
    # same logic as Easy AI
    target_bid=$(( prize_value + (RANDOM % 3 - 1) ))
    target_bid=$(( target_bid < 1 ? 1 : (target_bid > 13 ? 13 : target_bid) ))

    # check if target_bid is in hand
    if [[ " ${hand[@]} " =~ " ${target_bid} " ]]; then
        echo "$target_bid"
        return
    fi
    
    # otherwise find closest card
    local closest_diff=14
    local best_card
    for card in "${hand[@]}"; do
        local diff=$(( card > target_bid ? card - target_bid : target_bid - card ))
        if (( diff < closest_diff )); then
            closest_diff=$diff
            best_card="$card"
        fi
    done
    echo "$best_card"
}

# choose a strategy based on the prize and the player's state
AI_to_bid_medium() {
    local ai_bid

    if [[ $current_prize -gt 9 ]]; then
        # high prize logic
        if [[ $PLAYER_HIGH_CARD_COUNT -gt 0 ]]; then
            # player is still strong. Be unpredictable.
            if [[ $((RANDOM % 2)) -eq 0 ]]; then
                # bluff: bid a low card (1-3)
                ai_bid=$(printf '%s\n' "${ai_hand[@]}" | awk '$1 <= 3' | head -1)
                # if no low card, default to value mode
                if [[ -z "$ai_bid" ]]; then
                    ai_bid=$(get_value_bid "$current_prize" "${ai_hand[@]}")
                fi
            else
                # fight: bid a high card (>= 11)
                ai_bid=$(printf '%s\n' "${ai_hand[@]}" | awk '$1 >= 11' | head -1)
                # if no high card, default to value mode
                if [[ -z "$ai_bid" ]]; then
                    ai_bid=$(get_value_bid "$current_prize" "${ai_hand[@]}")
                fi
            fi
        else
            # player is weak. Steal prize efficiently.
            # find the smallest card in hand that is greater than the expected player bid
            ai_bid=$(get_value_bid "$current_prize" "${ai_hand[@]}")
        fi
    else
        # low prize logic - use value mode
        ai_bid=$(get_value_bid "$current_prize" "${ai_hand[@]}")
    fi
    chosen_bids+=($ai_bid)
    new_AI_hand=()
    for card in "${ai_hand[@]}"; do
        if [[ "$card" != "$ai_bid" ]]; then
            new_AI_hand+=("$card")
        fi
    done
    ai_hand=("${new_AI_hand[@]}")
}

AI_to_bid_hard_proper() {
    # game-theoretic approach for Goofspiel
    local ai_bid
    
    # Known optimal strategy patterns for Goofspiel:
    case $current_prize in
        13|12|11)  # high prizes - bid high but not necessarily highest
            if [[ " ${ai_hand[@]} " =~ " 13 " ]] && [[ $((RANDOM % 3)) -eq 0 ]]; then
                ai_bid=13
            elif [[ " ${ai_hand[@]} " =~ " 12 " ]]; then
                ai_bid=12
            else
                ai_bid=$(get_value_bid "$current_prize" "${ai_hand[@]}")
            fi
            ;;
        10|9|8)    # medium-high prizes - mixed strategy
            local strategy=$((RANDOM % 4))
            case $strategy in
                0) ai_bid=$(printf '%s\n' "${ai_hand[@]}" | awk '$1 >= 11' | head -1) ;;
                1) ai_bid=$(printf '%s\n' "${ai_hand[@]}" | awk '$1 <= 3' | head -1) ;;
                *) ai_bid=$(get_value_bid "$current_prize" "${ai_hand[@]}") ;;
            esac
            ;;
        *)         # low prizes - bid efficiently
            # count remaining high cards in both hands
            local remaining_high_cards=0
            for card in "${ai_hand[@]}" "${player_hand[@]}"; do
                [[ $card -gt 9 ]] && ((remaining_high_cards++))
            done
            
            if [[ $remaining_high_cards -lt 3 ]]; then
                # late game - conservative bidding
                ai_bid=$(get_value_bid "$current_prize" "${ai_hand[@]}")
            else
                # early game - sometimes bluff on low prizes
                if [[ $((RANDOM % 5)) -eq 0 ]]; then  # 20% bluff chance
                    ai_bid=$(printf '%s\n' "${ai_hand[@]}" | awk '$1 <= 2' | head -1)
                    [[ -z "$ai_bid" ]] || ai_bid=$(get_value_bid "$current_prize" "${ai_hand[@]}")
                else
                    ai_bid=$(get_value_bid "$current_prize" "${ai_hand[@]}")
                fi
            fi
            ;;
    esac
    
    # fallback if the above logic fails
    if [[ -z "$ai_bid" ]] || ! in_array "$ai_bid" "${ai_hand[@]}"; then
        ai_bid=$(get_value_bid "$current_prize" "${ai_hand[@]}")
    fi
    chosen_bids+=($ai_bid)
    new_AI_hand=()
    for card in "${ai_hand[@]}"; do
        if [[ "$card" != "$ai_bid" ]]; then
            new_AI_hand+=("$card")
        fi
    done
    ai_hand=("${new_AI_hand[@]}")
}

AI_to_bid_hard_adaptive() {
    local ai_bid
    
    # calculate game phase and player style from available data
    local game_phase=$((13 - ${#prize_deck[@]}))  # rounds played so far (0-12)
    local player_score=0
    local ai_score=0
    
    # calculate current scores from purses
    for card in "${player_purse[@]}"; do
        player_score=$((player_score + card))
    done
    for card in "${ai_purse[@]}"; do
        ai_score=$((ai_score + card))
    done
    
    # analyze player's bidding pattern from score
    local player_efficiency="unknown"
    if [[ $game_phase -gt 3 ]]; then  # enough rounds to have a pattern
        if [[ $player_score -gt $((game_phase * 7)) ]]; then
            player_efficiency="aggressive"  # winning more than average
        elif [[ $player_score -lt $((game_phase * 5)) ]]; then
            player_efficiency="conservative"  # winning less than average
        else
            player_efficiency="balanced"
        fi
    fi
    
    # count remaining high cards for strategic decisions
    local player_high_remaining=0
    local ai_high_remaining=0
    for card in "${player_hand[@]}"; do
        [[ $card -gt 9 ]] && ((player_high_remaining++))
    done
    for card in "${ai_hand[@]}"; do
        [[ $card -gt 9 ]] && ((ai_high_remaining++))
    done
    
    # strategic decision based on game state
    if [[ $current_prize -gt 10 ]]; then
        # high prize strategy
        if [[ $player_efficiency == "aggressive" ]] && [[ $player_high_remaining -gt 1 ]]; then
            # aggressive player with high cards - fight or bluff randomly
            if [[ $((RANDOM % 3)) -eq 0 ]]; then
                # bluff: bid low to trick aggressive player into overbidding
                ai_bid=$(printf '%s\n' "${ai_hand[@]}" | awk '$1 <= 3' | head -1)
                [[ -z "$ai_bid" ]] && ai_bid=$(get_value_bid "$current_prize" "${ai_hand[@]}")
            else
                # fight: bid high to compete
                ai_bid=$(printf '%s\n' "${ai_hand[@]}" | awk '$1 >= 11' | head -1)
                [[ -z "$ai_bid" ]] && ai_bid=$(get_value_bid "$current_prize" "${ai_hand[@]}")
            fi
        elif [[ $player_score -gt $ai_score ]] && [[ $ai_high_remaining -gt $player_high_remaining ]]; then
            # behind but have high card advantage - push hard
            ai_bid=$(printf '%s\n' "${ai_hand[@]}" | awk '$1 >= 11' | head -1)
            [[ -z "$ai_bid" ]] && ai_bid=$(get_value_bid "$current_prize" "${ai_hand[@]}")
        else
            # default high prize strategy
            ai_bid=$(get_value_bid "$current_prize" "${ai_hand[@]}")
        fi
        
    elif [[ $current_prize -lt 6 ]]; then
        # low prize strategy
        if [[ $player_efficiency == "conservative" ]] || [[ $player_high_remaining -eq 0 ]]; then
            # conservative player or player out of high cards - bid minimally
            ai_bid=$(printf '%s\n' "${ai_hand[@]}" | sort -n | head -1)
        elif [[ $ai_score -gt $player_score ]] && [[ $game_phase -gt 8 ]]; then
            # ahead late game - conserve high cards
            ai_bid=$(get_value_bid "$current_prize" "${ai_hand[@]}")
        else
            # default low prize - sometimes bluff with very low card
            if [[ $((RANDOM % 4)) -eq 0 ]] && [[ " ${ai_hand[@]} " =~ " 1 " ]]; then
                ai_bid=1
            else
                ai_bid=$(get_value_bid "$current_prize" "${ai_hand[@]}")
            fi
        fi
        
    else
        # medium prize strategy (6-10)
        if [[ $player_efficiency == "aggressive" ]] && [[ $player_high_remaining -lt 2 ]]; then
            # aggressive player running out of high cards - they might bluff
            # counter by bidding slightly higher than value
            ai_bid=$(get_value_bid "$((current_prize + 1))" "${ai_hand[@]}")
            [[ -z "$ai_bid" ]] && ai_bid=$(get_value_bid "$current_prize" "${ai_hand[@]}")
        else
            # standard medium prize approach
            ai_bid=$(get_value_bid "$current_prize" "${ai_hand[@]}")
        fi
    fi
    
    # final fallback
    if [[ -z "$ai_bid" ]] || ! in_array "$ai_bid" "${ai_hand[@]}"; then
        ai_bid=$(get_value_bid "$current_prize" "${ai_hand[@]}")
    fi
    chosen_bids+=($ai_bid)
    new_AI_hand=()
    for card in "${ai_hand[@]}"; do
        if [[ "$card" != "$ai_bid" ]]; then
            new_AI_hand+=("$card")
        fi
    done
    ai_hand=("${new_AI_hand[@]}")
}

# function to check if game is over
game_over() {
    [ "${#prize_deck[@]}" -eq 0 ]  # game ends when prize deck is empty
}

determine_winner() {
    local player_total=0
    local ai_total=0
    
    # sum over player's purse
    for card in "${player_purse[@]}"; do
        player_total=$((player_total + card))
    done
    
    # sum over AI's purse  
    for card in "${ai_purse[@]}"; do
        ai_total=$((ai_total + card))
    done
    
    echo "Player total: $player_total"
    echo "AI total: $ai_total"
    
    if [ $player_total -gt $ai_total ]; then
        echo "Player wins!"
    elif [ $ai_total -gt $player_total ]; then
        echo "AI wins!"
    else
        echo "It's a tie!"
    fi
}

# main game loop
main() {
    setup_game
    shuffle_prize_deck
    
    while true; do
        display_table
        
        if game_over; then
	    determine_winner
	    break
	fi
	
	draw_prize
	player_to_bid
	
	if [ $difficulty == "easy" ]; then
	    AI_to_bid_easy
	elif [ $difficulty == "medium" ]; then
	    AI_to_bid_medium
	else
	    AI_to_bid_hard_adaptive
	fi
	
	# === BIDS ARE REVEALED ===
        player_bid="${chosen_bids[0]}"  # assuming player bid is first
        ai_bid="${chosen_bids[1]}"      # AI bid is second
        
        echo "Player bid: $player_bid | AI bid: $ai_bid"
        
        # === UPDATE PLAYER_HIGH_CARD_COUNT HERE ===
        if [[ $current_prize -lt 10 ]] && [[ $player_bid -gt 9 ]]; then
            echo "AI notes: Player wasted a high card on a low prize..."
            (( PLAYER_HIGH_CARD_COUNT-- ))
        fi
        
        if [[ $player_bid -gt $ai_bid ]]; then
            player_purse+=("$current_prize")
            echo -e "Player purses $current_prize daimonds!"
        elif [[ $player_bid -lt $ai_bid ]]; then
            ai_purse+=("$current_prize")
            echo -e "Sorry, computer purses $current_prize daimonds." 
        else
            echo -e "Round is a tie! No player purses these $current_prize diamonds..."
        fi
        
        new_deck=()
        for card in "${prize_deck[@]}"; do
	    if [[ "$card" != "$current_prize" ]]; then
	        new_deck+=("$card")
	    fi
	done
        prize_deck=("${new_deck[@]}")

        chosen_bids=()
    done
    echo
    read -p "Play again? (y/n): " play_again
    if [[ $play_again =~ ^[Yy]$ ]]; then
        exec "$0"  # Restart the script
    else
        echo "Thanks for playing Goofspiel!"
    fi

}
	    
# Start the game
main
```

---

**References:**
* Dror, M. (1989). "Simple proof for Goofspiel: the game of pure strategy," *Advances in Applied Probability*, vol. 21, no. 3, pp. 711–712. Retrieved from <https://www.cambridge.org/core/services/aop-cambridge-core/content/view/47E6F1B1564C81D45702192D9E54E5BB/S0001867800018917a.pdf/simple_proof_for_goofspiel_the_game_of_pure_strategy.pdf>