
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
  @name == c?.name

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
  c = Session.get('currentClue')
  next = Clues.findOne({name: c.next})
  if next? then moveToClue(next)

@toPrevClue = ->
  c = Session.get('currentClue')
  prev = Clues.findOne({name: c.prev})
  if prev? then moveToClue(prev)
    
@updateClueOnMove = ->
  if b = Puzzle.current()?.currentBlock()
    if Session.get('currentDirection') == ACROSS
      Session.set('currentClue', Clues.findOne({name: b.clueAcross}))
    if Session.get('currentDirection') == DOWN
      Session.set('currentClue', Clues.findOne({name: b.clueDown}))