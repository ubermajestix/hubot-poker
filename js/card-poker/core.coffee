_ = require('underscore')


module.exports.Card = class Card
  constructor: (@rank, @suit) ->

  to_s: ->
    "#{@rank.label}#{@suit.value}"

  display: ->
    "[#{@rank.label}#{@suit.label}]"


module.exports.Rank = class Rank
  constructor: (@value, @label) ->


module.exports.Suit = class Suit
  constructor: (@value, @label) ->


module.exports.Deck = class Deck
  constructor: ->
    ranks = (new Rank(r, r) for r in [2..10])
    ranks.push new Rank(11, 'J')
    ranks.push new Rank(12, 'Q')
    ranks.push new Rank(13, 'K')
    ranks.push new Rank(14, 'A')

    suits = (new Suit(pair[0], pair[1]) for pair in _.zip(
        ['S', 'H', 'C', 'D'],
        [':spades:', ':hearts:', ':clubs:', ':diamonds:'])
    )

    @cards = _.flatten(new Card(r, s) for r in ranks for s in suits)

  shuffle: ->
    @cards = _.shuffle(@cards)

  deal: (count=1) ->
    @cards.shift() for [1..count]


module.exports.Hand = class Hand
  constructor: (@cards) ->
