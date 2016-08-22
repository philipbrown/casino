# Casino

**An example of a Casino supervision tree in Elixir**

## Installation

Clone the repository:
```
git@github.com:philipbrown/casino.git && cd casino
```

Fire up <code>iex</code>:
```
iex -S mix
```

## Usage
```elixir
# Add a new player
Casino.add_player("Philip", 100)

# Add another player
Casino.add_player("Jane", 250)

# List all of the players
Casino.list_players

# Remove a player
Casino.remove_player(2)

# Count the active blackjack tables
Casino.count_blackjack_tables

# Add 3 more blackjack tables
Casino.add_blackjack_table(3)

# Count the blackjack tables again
Casino.count_blackjack_tables

# Remove a blackjack table
Casino.remove_blackjack_table

# Count the blackjack tables one last time
Casino.count_blackjack_tables
```
