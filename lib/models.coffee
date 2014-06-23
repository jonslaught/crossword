@ACROSS = 'A'
@DOWN = 'D'


@Puzzles = new Meteor.Collection "puzzles",
  transform: (doc) ->
    return new Puzzle(doc)

@Guesses = new Meteor.Collection "guesses",
  transform: (doc) ->
    return new Guess(doc)  

@Positions = new Meteor.Collection "positions"

class @Puzzle
  constructor: (doc) ->
    _.extend(@, doc)

  block: (xOrIndex, y) ->
    if not xOrIndex?
      return

    if y?
      x = xOrIndex
      return @grid[y][x]
    else
      index = xOrIndex
      return @block(@coordinates[index].x, @coordinates[index].y)

  clue: (id) ->
    _.findWhere @clues, {_id: id}

  # Client only
  currentBlock: ->
    @block(Session.get('currentBlockIndex'))

  currentClue: ->
    Session.get('currentClue')

  makeGuess: (guess) ->
    Guesses.insert
      puzzleId: @_id
      blockIndex: Session.get('currentBlockIndex')
      guess: guess
      time: new Date()

  @current: ->
    Puzzles.findOne Session.get('currentPuzzleId')

class @Guess

  constructor: (doc) ->
    _.extend(@, doc)

