Template.puzzle.puzzle = ->
  p = Puzzles.findOne()
  Session.set('currentPuzzleId', p?._id)
  return p

Template.clues.cluesAcross = ->
  p = Puzzles.findOne Session.get('currentPuzzleId')
  _.where p.clues, {'direction': ACROSS}

Template.clues.cluesDown = ->
  p = Puzzles.findOne Session.get('currentPuzzleId')
  _.where p.clues, {'direction': DOWN}