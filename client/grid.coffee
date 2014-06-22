Template.block.events
  'click .target': (event, template) ->
    Session.set('selectedBlockIndex', @index)

@findBlock = (blockIndex) -> $("[data-block-index=#{ blockIndex }]")
@findCurrentBlock = -> findBlock(Session.get('selectedBlockIndex'))

@getLatestGuess = (blockIndex) ->
  Guesses.findOne
    puzzleId: Session.get('currentPuzzleId')
    blockIndex: blockIndex
  ,
    sort:
      time: -1

Template.block.guess = ->
  g = getLatestGuess(@index)

Template.grid.created = ->

  # Keep the input box in sync with the selected block
  Deps.autorun =>
      $('#input').detach().appendTo(findCurrentBlock())
      $('#input').show()

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
          Session.set 'selectedBlockIndex', b.index
          return false
        if p.block(x, y).white # white block, keep it
          Session.set 'selectedBlockIndex', p.block(x, y).index
          return false

    letter = String.fromCharCode(key)

    if letter

      Guesses.insert
        puzzleId: p._id
        blockIndex: b.index
        guess: letter
        time: new Date()

    return true
