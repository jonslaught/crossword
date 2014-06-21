
@currentPuzzle = ->
  Puzzles.findOne Session.get('currentPuzzleId')

Deps.autorun ->
  Session.set('currentPuzzleId', Puzzles.findOne()?._id)

Template.grid.rows = ->
  currentPuzzle()?.grid

Template.block.selected = ->
  @index == Session.get('selectedBlock')?.index

Template.grid.events
  'click .target': (event, template) ->
    Session.set('selectedBlock', @)

Template.grid.created = ->
  $(document).keydown (event) ->
    b = Session.get('selectedBlock')
    p = currentPuzzle()
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