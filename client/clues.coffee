
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

Template.clues.created = ->
  # Keep current clue in view
  Deps.autorun =>
    c = findCurrentClue()
    if c[0] then $('.scrollable').scrollTo(c)

@findClue = (clue) -> $("[data-clue-id=#{ clue?._id }]")
@findCurrentClue = -> findClue(Session.get('currentClue'))
   
@moveToClue = (clue) ->
  Session.set('currentClue', clue)
  Session.set('currentBlockIndex', c.start)
  Session.set('currentDirection', c.direction)

@toNextClue = ->
  p = Puzzle.current()
  c = Session.get('currentClue')
  i = _.findIndex p.clues,
    number: c.number
    direction: Session.get('currentDirection')
  next = p.clues[i+1]
  if next? then moveToClue(next)
    
Deps.autorun ->
  log 'current clue', Puzzle.current()?.currentClue()
  log 'current direction', Session.get('currentDirection')