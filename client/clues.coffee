
Template.clues.cluesAcross = ->
  p = Puzzle.current()
  _.where p.clues, {'direction': ACROSS}

Template.clues.cluesDown = ->
  p = Puzzle.current()
  _.where p.clues, {'direction': DOWN}

Template.clues.events
  'click .clue': -> moveToClue(@)

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

  Deps.autorun =>
    updateClueOnMove()

@findClue = (clue) -> $("[data-clue-id=#{ clue?._id }]")
@findCurrentClue = -> findClue(Session.get('currentClue'))
   
@moveToClue = (clue) ->
  Session.set('currentClue', clue)
  Session.set('currentBlockIndex', clue.start)
  Session.set('currentDirection', clue.direction)

@toNextClue = ->
  p = Puzzle.current()
  c = Session.get('currentClue')
  i = _.findIndex p.clues,
    number: c.number
    direction: Session.get('currentDirection')
  next = p.clues[i+1]
  if next? then moveToClue(next)
    
@updateClueOnMove = ->

  if b = Puzzle.current().currentBlock()
    if Session.get('currentDirection') == ACROSS
      Session.set('currentClue', b.clueAcross)
    if Session.get('currentDirection') == DOWN
      Session.set('currentClue', b.clueDown)