
@currentPuzzle = ->
  Puzzles.findOne Session.get('currentPuzzleId')

Deps.autorun ->
  Session.set('currentPuzzleId', Puzzles.findOne()?._id)

Template.grid.rows = ->
  currentPuzzle()?.rows

Template.grid.events
  'click .target': (event, template) ->
    $('.input').hide()
    t = event.target
    $(t).closest('.block').find('.input').show()
