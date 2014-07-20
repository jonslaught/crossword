# Initialize

Session.setDefault('currentDirection', ACROSS)

Template.header.events
  'click #reveal': ->
    $('.answer').show()

  'click #check': ->
    Session.set('checkTime', new Date())

Template.puzzle.date = ->
  Puzzle.current()?.getDate()