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

@findClue = (clue) -> $("[data-clue-id=#{ clue?._id }]")
@findCurrentClue = -> findClue(Session.get('currentClue'))
@visibleInContainer = (elt, container) ->
  eltRect = $(elt).get(0).getBoundingClientRect()
  containerRect = $(container).get(0).getBoundingClientRect()
  eltRect.top >= containerRect.top and eltRect.bottom <= containerRect.bottom

Template.clues.created = ->
  Deps.autorun =>
    c = findCurrentClue()
    if c[0] and not visibleInContainer(c, $('.scrollable'))
      $('.scrollable').scrollTo(c)