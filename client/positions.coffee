@bounds = (elt) ->
  p = $(elt).position()
  return {
    top: p.top
    left: p.left
    right: p.left + $(elt).width()
    bottom: p.top + $(elt).height() 
    height: $(elt).height()
    width: $(elt).width()
  }

Template.positions.rendered = ->
  Deps.autorun =>
    trackPosition()

  Deps.autorun =>
    if Session.get('blocksRendered')
      showPositions()

@trackPosition = ->
  if Session.get('loadedPuzzle')
    puzzle = Puzzle.current()
    b = Session.get('currentBlockIndex') 
    c = Session.get('currentClue')?._id
    if b? and c? and puzzle?
      p = Positions.upsert
        puzzleId: puzzle._id
        userId: Meteor.userId()
      ,
        $set:
          blockIndex: b
          clueId: c

@showPositions = ->

  puzzle = Puzzle.current()
  if not puzzle? then return

  SPEED = 200;

  positions = Positions.find({puzzleId: puzzle._id}).fetch()
  for p in positions
    p.block = puzzle.block(p.blockIndex)

  boxColor = d3.scale.category10()
  boxes = d3.select('.active-clues').selectAll('.active-clue').data(positions)
  boxes.enter().append('div').attr('class','active-clue')
  boxes.exit().remove()
  boxes
    .style 'background-color', (d, i) -> boxColor(i)
    .each (d) ->
      clue = Clues.findOne(d.clueId)
      start = findBlock(clue?.start)
      end = findBlock(clue?.end)
      d3.select(@).interrupt().transition().duration(SPEED).style
        'top': bounds(start).top + 'px'
        'left': bounds(start).left + 'px'
        'height': bounds(end).top - bounds(start).top + bounds(start).height + 1 + 'px'
        'width': bounds(end).left - bounds(start).left + bounds(start).width + 1 + 'px'

  inputs = d3.select('.active-boxes').selectAll('.active-box').data(positions)
  inputs.enter().append('div').attr('class','active-box').html("<img class='head' src='' />")
  inputs.exit().remove()
  inputs
    .select('.head').attr('src', (d) -> Meteor.users.findOne(d.userId)?.profile?.picture or 'http://ts2.mm.bing.net/th?q=squirrel&w=50&h=50&c=1&pid=1.7&mkt=en-US&adlt=off&t=1')
  inputs
    .style 'border-color', (d, i) -> boxColor(i)
    .interrupt().transition().duration(SPEED)
    .style 'top', (d) -> bounds(findBlock(d.blockIndex)).top + 'px'
    .style 'left', (d) -> bounds(findBlock(d.blockIndex)).left + 'px'