# Initialize

Session.setDefault('currentDirection', ACROSS)

Template.puzzle.puzzle = ->
  p = Puzzles.findOne()
  Session.set('currentPuzzleId', p?._id)
  Session.set('currentClue', p?.clues[0])
  return p