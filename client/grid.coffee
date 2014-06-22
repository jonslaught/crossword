Template.block.events
  'click .target': (event, template) ->
    Session.set('currentBlockIndex', @index)

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


moveToNext = ->

  d = Session.get('currentDirection')
  if d == ACROSS
    move = -> x += 1
  if d == DOWN
    move = -> y += 1

  p = Puzzle.current()
  b = p.currentBlock()

  [x, y] = [b.x, b.y]

  loop
    move()
    if x < 0 or y < 0 or x >= p.width or y >= p.height # edge, go back
      Session.set 'currentBlockIndex', b.index
      return false
    if p.block(x, y).white # white block, keep it
      Session.set 'currentBlockIndex', p.block(x, y).index
      return false



Template.block.guess = ->
  g = getLatestGuess(@index)

Template.grid.created = ->

  # Keep the input box in sync with the selected block
  Deps.autorun =>
      $('#input').detach().appendTo(findCurrentBlock())
      $('#input').show()

  # Change selection, direction with each clue
  Deps.autorun =>
    p = @data
    if c = p.currentClue()
      Session.set('currentBlockIndex', c.start)
      Session.set('currentDirection', c.direction)

  # Change clue with each move
  Deps.autorun =>
    #todo speed this up, and catch stuff that's in between numbers, and zoom to selected clue
    p = @data
    c = _.where(p.clues, {start: Session.get('currentBlockIndex')})?[0]
    Session.set('currentClue', c)

  # Detect key presses, i.e. arrows
  $(document).keydown (event) =>

    p = @data
    b = p.currentBlock()

    key = event.which

    move = switch key
      when 37 then -> x -= 1
      when 38 then -> y -= 1
      when 39 then -> x += 1
      when 40 then -> y += 1

    if move
      [x, y] = [b.x, b.y]

      loop
        move()
        if x < 0 or y < 0 or x >= p.width or y >= p.height # edge, go back
          Session.set 'currentBlockIndex', b.index
          return false
        if p.block(x, y).white # white block, keep it
          Session.set 'currentBlockIndex', p.block(x, y).index
          return false

    letter = String.fromCharCode(key)

    if letter

      Guesses.insert
        puzzleId: p._id
        blockIndex: b.index
        guess: letter
        time: new Date()

      moveToNext()

    return true
