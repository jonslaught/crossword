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

  [x, y] = [b.x, b.y]

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

Template.block.events
  'click .target': (event, template) ->
    Session.set('currentBlockIndex', @index)

# Grid setup

Template.grid.created = ->

  # Detect key presses
  $(document).keydown (event) =>

    p = @data
    d = Session.get('currentDirection')
    key = event.which

    # Arrow keys
    if 37 <= key <= 40
      event.preventDefault()
      return moveToNext(key, true)

    # Backspace or delete
    if key == 8 or key == 46
      event.preventDefault()
      p.makeGuess("")
      return moveToNext(d, false, true)

    # Tab, enter
    if key == 9 or key == 13
      event.preventDefault()
      toNextClue()
      return false

    # Letters
    if 65 <= key <= 90
      #event.preventDefault()
      letter = String.fromCharCode(key)
      p.makeGuess(letter)
      return moveToNext(d, false)

    return true
