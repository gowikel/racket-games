# racket-games
This repo contains the games that I made when I was learning racket with the awesome book
'Real of Racket. Learn to Program, One Game at a Time!' Most of them are very similar to
the explained in the book, with some modifications to do them funnier.

## Guess my number
This game starts a little screen with a number. The machine tries to guess a number
that you thought and you say bigger of lower to give hints. Sooner or later the
machine should find your number.

The machine uses a binary search to do an optimal search between all possible numbers.
To do things more interesting, I allow to search any positive number (instead of
numbers between 0-100). Because of that, the machine must adapt the algorithm at the
beginning, increasing the search range until you press the 'lower' button.
