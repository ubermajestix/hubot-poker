_ = require('underscore')
AiPlayer = require('../js/token-poker/ai-player')
BaseGame = require('../js/token-poker/base-game')
Dealer = require('../js/token-poker/dealer')
FakeRandom = require('./fake-random')
GameCommand = require('../js/token-poker/game-command')

describe 'AiPlayer', ->
  dealer = null

  beforeEach ->
    dealer = new Dealer
    dealer.currentGameClass = FakeGame
    dealer.startNewGame()

  it 'plays rest of game at random when added to it', ->
    ai = new AiPlayer('foo', dealer)
    result = ai.doSomething(0)
    expect(result).toBe 'foo played 123123'

    result = ai.doSomething(1)
    expect(result).toBe "foo bet 30"

  it 'calls things at random when not fed a function index', ->
    ai = new AiPlayer('bar', dealer)
    _.times(20, ->
      result = ai.doSomething()
      expect(result[0..2]).toBe 'bar'
    )

  it 'dies when killed', ->
    ai = new AiPlayer('bar', dealer)
    result = ai.doSomething()
    expect(result).toNotBe undefined
    ai.die()
    result = ai.doSomething()
    expect(result).toBe undefined

  it 'stops acting after a limit', ->
    ai = new AiPlayer('bar', dealer)
    _.times(20, ->
      ai.doSomething()
      expect(ai.alive).toBe true
    )
    ai.doSomething()
    expect(ai.alive).toBe false


class FakeGame extends BaseGame
  constructor: ->
    super
    @randomProvider = new FakeRandom

  commands: -> [
    new GameCommand(/(\d{6})/i, this.play, => ("123123")),
    new GameCommand(/bet (\d+)/i, this.bet, => ("bet 30")),
  ]

  play: (@playerName, @playHand) ->
    "#{@playerName} played #{@playHand}"

  bet: (playerName, amount) ->
    "#{playerName} bet #{amount}"
