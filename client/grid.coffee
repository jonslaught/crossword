
@currentPuzzle = ->
  Puzzles.findOne Session.get('currentPuzzleId')

Deps.autorun ->
  Session.set('currentPuzzleId', Puzzles.findOne()?._id)

Template.grid.rows = ->
  currentPuzzle()?.rows

Template.block.selected = ->
  @index == Session.get('selectedBlock')?.index

Template.grid.events
  'click .target': (event, template) ->
    Session.set('selectedBlock', @)

Template.grid.created = ->
  $(document).keydown (event) ->
    b = Session.get('selectedBlock')
    i = b.index
    p = currentPuzzle()
    c = p.coordinates
    x = c[i].x
    y = c[i].y

    left = -> x -= 1
    up = -> y -= 1
    right = -> x += 1
    down = -> y += 1


    move = switch event.which
      when 37 then left
      when 38 then up
      when 39 then right
      when 40 then down


    # Move to the next open spot, if there is one
    for i in [1..20] #hacky but it works :/
      
      move()
      r = currentPuzzle().rows
      b = r[y][x]
      if b.block
        break

      # Reset bounds if passed
      x = Math.max(0, x)
      x = Math.min(x, p.width - 1)
      y = Math.max(0, y)
      y = Math.min(y, p.height - 1)

    Session.set('selectedBlock', b)
    event.preventDefault()
    return false