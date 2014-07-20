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

  # Client only
  currentBlock: ->
    @block(Session.get('currentBlockIndex'))

  currentClue: ->
    Session.get('currentClue')

  makeGuess: (guess) ->
    
    ###
    Guesses.upsert
      puzzleId: @_id
      blockIndex: Session.get('currentBlockIndex')
    ,
      $set:
        guess: guess
        markerType: Session.get('currentMarker')
        time: new Date()
    ###

    Guesses.insert
      puzzleId: @_id
      blockIndex: Session.get('currentBlockIndex')
      userId: Meteor.userId()
      guess: guess
      markerType: Session.get('currentMarker')
      time: new Date()

  undoGuess: ->
    g = Guesses.findOne
      userId: Meteor.userId()
    ,
      sort:
        time: -1
    if g?
      Guesses.remove g._id

  getDate: ->
    moment(new Date(@nyt_date  + " 12:00:00"))

  @current: ->
    Puzzles.findOne Session.get('currentPuzzleId')

