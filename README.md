# game_of_war

## Installation:
================
- clone repo into a local directory
- You may need to run **rvm use ruby-2.3.0@war** if rvm doesn't pick up the correct versions from the ruby-version and ruby-gemset files
- Run **bundle install**

## Game play:
================
- cd to project root, enter Rails console with ** rails c**
- Begin game by creating a new instance, telling it the number of cards per war and number of players. 
- Players will be chosen at random based on count. Game will accept 2-4 players.
- *start_game* method sets up initial defaults for the game, including a deck, and deals the cards
- Thereafter, simply continue to run *play_turn*. 
- After each turn, a small stats & summary will be shown. 
.. - If there is a battle, battle results will be shown.
.. - If there is a war, battle results and war results will be shown.

================
- **g = Game.new(1,2)**
- **g.start_game**
- **g.play_turn**
================



## Ending Game:
================
- When one player has either gained or lost all cards, the game is over.
- This can take a long time, so alternatively, you can end the game artificially, by calling *end_game*
- This will award a victory to the player with the highest number of cards at that time.


================
- **g.end_game**
================


![alt text](https://github.com/varkerkamachi/game_of_war/public/game_play_screenshot.png "Game play screenshot")