@findBlock = (blockIndex) -> $("[data-block-index=#{ blockIndex }]")
@findCurrentBlock = -> findBlock(Session.get('currentBlockIndex'))
@moveToNextBlock = ->
  p = Puzzle.current()
  b = p.currentBlock()

@getLatestGuess = (blockIndex) ->
  Guesses.findOne
    puzzleId: Session.get('currentPuzzleId')
    blockIndex: blockIndex
  ,
    sort:
      time: -1
      
@moveToNext = (direction, jumpOverBlacks, reverse) ->

  jumpOverBlacks ?= true
  reverse ?= false

  p = Puzzle.current()
  b = p.currentBlock()

  if b? and p?

    x = b.x
    y = b.y

    left = -> x -= 1
    right = -> x += 1
    up = -> y -= 1
    down = -> y += 1

    move = switch direction
      when 37 then left
      when 38 then up
      when 39 then right
      when 40 then down
      when ACROSS then (if reverse then left else right)
      when DOWN then (if reverse then up else down)

    loop
      move()
      if x < 0 or y < 0 or x >= p.width or y >= p.height # edge, go back
        Session.set 'currentBlockIndex', b.index
        return false
      if not p.block(x, y).white and not jumpOverBlacks # black block, stay
        Session.set 'currentBlockIndex', b.index
        return false
      if p.block(x, y).white # white block, keep it
        Session.set 'currentBlockIndex', p.block(x, y).index
        return false

# Blocks

Template.block.guess = ->
  g = getLatestGuess(@index)


Template.block.checked = ->

  g = getLatestGuess(@index)
  t = Session.get('checkTime')

  if g? and t? and g.time < t
    if g.guess == @answer 
      return "right"
    else
      return "wrong" 
    

Template.block.events
  'click .target': (event, template) ->
    Session.set('currentBlockIndex', @index)

# Grid setup

Template.grid.created = ->

  # Detect key presses
  $(document).off 'keydown'
  $(document).keydown (event) =>

    p = Puzzle.current()
    d = Session.get('currentDirection')
    key = event.which

    # Change direction
    if (key == 37 or key == 39) and Session.get('currentDirection') != ACROSS
      Session.set('currentDirection', ACROSS)
      event.preventDefault()
      return false
    
    if (key == 38 or key == 40) and Session.get('currentDirection') != DOWN
      Session.set('currentDirection', DOWN)
      event.preventDefault()
      return false

    # Move
    if 37 <= key <= 40 and not event.shiftKey
      event.preventDefault()
      return moveToNext(key, true)

    # Backspace or delete
    if key == 8 or key == 46
      event.preventDefault()
      p.makeGuess("")
      return moveToNext(d, false, true)

    # Tab, enter
    if (key == 9 or key == 13) and not event.shiftKey
      event.preventDefault()
      toNextClue()
      return false

    # Shift-Tab
    if (key == 9 or key == 13) and event.shiftKey
      event.preventDefault()
      toPrevClue()
      return false

    # Letters
    if (65 <= key <= 90) and not event.metaKey
      #event.preventDefault()
      letter = String.fromCharCode(key)
      p.makeGuess(letter)
      return moveToNext(d, false)

    # Ctrl-Z
    if key == 90 and event.metaKey
      event.preventDefault()
      Puzzle.current().undoGuess()
      return false

    return true
