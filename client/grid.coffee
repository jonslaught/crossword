
Template.puzzle.puzzle = ->
  p = Puzzles.findOne()
  Session.set('currentPuzzleId', p?._id)
  return p

Template.block.events
  'click .target': (event, template) ->
    Session.set('selectedBlock', @)

findBlock = (b) -> $("[data-block-index=#{ b.index }]")

Template.block.guess = ->
  g = Guesses.findOne
    puzzleId: Session.get('currentPuzzleId')
    blockIndex: @index
  ,
    sort: ['created','desc']

Template.grid.created = ->
  p = @data
  b = Session.get('selectedBlock')

  # Keep the input box in sync with the selected block
  Deps.autorun ->
    if b = Session.get('selectedBlock')
      $('#input').detach().appendTo(findBlock(b))
      $('#input').show()

  # Detect key presses, i.e. arrows
  $(document).keydown (event) ->

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
          Session.set 'selectedBlock', b
          return false
        if p.block(x, y).white # white block, keep it
          Session.set 'selectedBlock', p.block(x, y)
          return false

    letter = String.fromCharCode(key)

    if letter

      Guesses.insert
        puzzleId: p._id
        blockIndex: b.index
        guess: letter
        time: new Date()

      $('#input').hide()







    return true

Template.input.guess = ->
  "A"