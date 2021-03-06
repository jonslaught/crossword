# Initialize

Session.setDefault('currentDirection', ACROSS)
Session.setDefault('currentMarker', PEN)
Session.setDefault('loadedPuzzle', false)

Template.header.events
  'click #reveal': ->
    $('.answer').show()

  'click #check': ->
    Session.set('checkTime', new Date())

  'click #pencil': ->
    if Session.get('currentMarker') == PEN
      Session.set('currentMarker', PENCIL)
    else
      Session.set('currentMarker', PEN)

  'click #undo': ->
    Puzzle.current().undoGuess()

Template.puzzle.date = ->
  Puzzle.current()?.getDate()

Template.header.pencilMode = ->
  Session.get('currentMarker') == PENCIL