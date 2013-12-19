# BaDEmporium (v2)

## Technical Details
### Blackjack: 2 primary controllers

+ blackjack\_controller: controls _flow_ of blackjack games:
  + create games
  + destroy games
  + join games (and dealing in, starting game)
  + restart games
+ api\_controller: controls individual game actions:
  + hit
  + stand
  + double
  + split

* each of the api\_controller actions will perform the expected actions as well as any resulting actions that control the flow of the games (e.g. calling hit will give the current player a card and check for busts and move on to the next player if necessary).