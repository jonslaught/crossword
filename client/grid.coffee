Template.puzzle.puzzle = ->
  Puzzles.findOne()

Template.block.selected = ->
  @index == Session.get('selectedBlock')?.index

Template.grid.events
  'click .target': (event, template) ->
    Session.set('selectedBlock', @)

findBlock = (b) -> $("[data-block-index=#{ b.index }]")

Template.grid.created = ->
  p = @data

  Deps.autorun ->
    if b = Session.get('selectedBlock')
      td = findBlock(b)
      $('.input').detach().appendTo(td)    
      $('.input').text(b.answer)

  $(document).keydown (event) ->

    b = Session.get('selectedBlock')
    [x, y] = [b.x, b.y]

    move = switch event.which
      when 37 then -> x -= 1
      when 38 then -> y -= 1
      when 39 then -> x += 1
      when 40 then -> y += 1

    if move
      start = p.block(x, y)

      loop
        move()
        if x < 0 or y < 0 or x >= p.width or y >= p.height # edge
          b = start
          break
        if p.block(x, y).white # white block
          b = p.block(x, y)
          break

      Session.set('selectedBlock', b)

    event.preventDefault()
    return false

