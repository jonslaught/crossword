
@currentPuzzle = ->
  Puzzles.findOne Session.get('currentPuzzleId')

Deps.autorun ->
  Session.set('currentPuzzleId', Puzzles.findOne()?._id)

Template.grid.rows = ->
  currentPuzzle()?.rows