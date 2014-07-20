
Template.clues.cluesAcross = ->
  Clues.find
    puzzleId: Session.get('currentPuzzleId')
    direction: ACROSS


Template.clues.cluesDown = ->
  Clues.find
    puzzleId: Session.get('currentPuzzleId')
    direction: DOWN

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
  next = Clues.findOne({name: c.next})
  if next? then moveToClue(next)
    
@updateClueOnMove = ->
  if b = Puzzle.current()?.currentBlock()
    if Session.get('currentDirection') == ACROSS
      Session.set('currentClue', Clues.findOne({name: b.clueAcross}))
    if Session.get('currentDirection') == DOWN
      Session.set('currentClue', Clues.findOne({name: b.clueDown}))