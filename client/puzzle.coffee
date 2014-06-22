Session.setDefault('currentDirection', ACROSS)

Template.puzzle.puzzle = ->
  p = Puzzles.findOne()
  Session.set('currentPuzzleId', p?._id)
  Session.set('currentClue', p?.clues[0])
  return p

Template.clues.cluesAcross = ->
  p = Puzzle.current()
  _.where p.clues, {'direction': ACROSS}

Template.clues.cluesDown = ->
  p = Puzzle.current()
  _.where p.clues, {'direction': DOWN}

Template.clues.events
  'click .clue': ->
    Session.set('currentClue', @)

Template.currentClue.clue = ->
  Session.get('currentClue')

Template.clue.selected = ->
  c = Session.get('currentClue')
  @number == c?.number and @direction == c?.direction
