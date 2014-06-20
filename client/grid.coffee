
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
  log 'rendering...'
  $(document).keyup (event) ->
    log 'keydown', event.keyCode
    b = Session.get('selectedBlock')
    i = b.index
    c = currentPuzzle().coordinates
    x = c[i].x
    y = c[i].y

    switch event.which
      when 37 then x -= 1 # LEFT
      when 38 then y -= 1 # UP
      when 39 then x += 1 # RIGHT
      when 40 then y += 1 # DOWN

    r = currentPuzzle().rows
    log x, y
    b = r[x][y]

    Session.set('selectedBlock', b)