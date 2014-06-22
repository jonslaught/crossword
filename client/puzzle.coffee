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

Template.clues.events
  'click .clue': ->
    Session.set('selectedClue', @)

Template.currentClue.clue = ->
  Session.get('selectedClue')

Template.clue.selected = ->
  c = Session.get('selectedClue')
  @number == c.number and @direction == c.direction