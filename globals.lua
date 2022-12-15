Class = require 'libs.middleclass'

DEBUG = true

-- Enums
CombinationType = {
  SINGLE = 1,
  PAIR = 2,
  TRIPLET = 3,
  QUARTET = 4,
  SEQUENCE = 5,
  DOUBLE_SEQUENCE = 6,
}

Rank = {
  THREE = 1,
  FOUR = 2,
  FIVE = 3,
  SIX = 4,
  SEVEN = 5,
  EIGHT = 6,
  NINE = 7,
  TEN = 8,
  JACK = 9,
  QUEEN = 10,
  KING = 11,
  ACE = 12,
  TWO = 13,
}

Suit = {
  SPADES = 1,
  CLUBS = 2,
  DIAMONDS = 3,
  HEARTS = 4,
}

AIID = {
  UPPER = 1,
  LEFT = 2,
  RIGHT = 3,
}