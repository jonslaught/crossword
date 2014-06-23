
Template.input.guess = ->
  g = getLatestGuess(Session.get('currentBlockIndex'))


Template.positions.rendered = ->
  if p = @data
    Deps.autorun =>
      trackPosition(p)

    Deps.autorun =>
      showPositions(@, p)

@trackPosition = (puzzle) ->
    p = Positions.upsert
      puzzleId: puzzle._id
      userId: Meteor.userId()
    ,
      $set:
        blockIndex: Session.get('currentBlockIndex')
        clueId: Session.get('currentClue')?._id

@showPositions = (template, puzzle) ->

  positions = Positions.find
    puzzleId: puzzle._id
  .fetch()

  for p in positions
    p.block = puzzle.block(p.blockIndex)

  heads = d3.select(template.find('.heads'))
    .selectAll('.head')
    .data(positions)

  heads.enter()
    .append('div').attr('class','head')
    .html((d) -> Template.position())

  heads.exit()
    .remove()

  heads.select('img')
    #.style('visibility', (d) -> if d.userId == Meteor.userId() then 'hidden' else 'visible')
    .attr 'src', (d) ->
      if user = Meteor.users.findOne(d.userId)
        picture = user.profile.picture
      else
        picture = 'http://ts2.mm.bing.net/th?q=squirrel&w=50&h=50&c=1&pid=1.7&mkt=en-US&adlt=off&t=1'


  heads.transition().duration(500)
    .style 'top', (d) -> 
      return findBlock(d.block.index).position().top + 'px'
    .style 'left', (d) -> 
      return findBlock(d.block.index).position().left + 'px'

  boxColor = d3.scale.category10()

  boxes = d3.select(template.find('.clueBoxes'))
    .selectAll('.clueBox')
    .data(positions)
  boxes.enter().append('div').attr('class','clueBox')
  boxes.exit().remove()

  boxes
    .style 'border-color', (d, i) ->
      boxColor(i)
    .transition().duration(500)
    .style 'top', (d) ->
      if clue = Puzzle.current().clue(d.clueId)
        findBlock(clue.start).position().top + 'px'
    .style 'left', (d) ->
      if clue = Puzzle.current().clue(d.clueId)
        findBlock(clue.start).position().left + 'px'
    .style 'height', (d) ->
      if clue = Puzzle.current().clue(d.clueId)
        findBlock(clue.end).position().top - findBlock(clue.start).position().top + findBlock(clue.end).height() + 1 + 'px' #super janky :(
    .style 'width', (d) ->
      if clue = Puzzle.current().clue(d.clueId)
        findBlock(clue.end).position().left - findBlock(clue.start).position().left + findBlock(clue.end).width() + 1 + 'px'

###
@showActiveBlocks = ->

  p = Puzzle.current()

  block = p.currentBlock()
  clue = p.currentClue()

  # Find the blocks that are active
  startBlock = p.block(clue.start)
  endBlock = p.block(clue.end)

  # Selected blocks
  if clue.direction == ACROSS
    y = startBlock.y
    for x in [startBlock.x .. endBlock.x]
      # mark this block as selected

  if clue.direction == DOWN
    x = startBlock.x
    for x in [startBlock.y .. endBlock.y]
      # mark this block as selected


  if clue.direction == ACROSS
    findBlock()
###