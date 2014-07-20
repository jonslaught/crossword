@ACROSS = 'A'
@DOWN = 'D'

@PEN = 'pen'
@PENCIL = 'pencil'

@Puzzles = new Meteor.Collection "puzzles",
  transform: (doc) ->
    return new Puzzle(doc)

@Guesses = new Meteor.Collection "guesses",
  transform: (doc) ->
    return new Guess(doc)  

@Positions = new Meteor.Collection "positions"


@Rooms = new Meteor.Collection "rooms"

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
    Guesses.upsert
      puzzleId: @_id
      blockIndex: Session.get('currentBlockIndex')
    ,
      $set:
        guess: guess
        markerType: Session.get('currentMarker')
        time: new Date()

  getDate: ->
    moment(new Date(@nyt_date  + " 12:00:00"))

  @current: ->
    Puzzles.findOne Session.get('currentPuzzleId')

class @Guess

  constructor: (doc) ->
    _.extend(@, doc)

