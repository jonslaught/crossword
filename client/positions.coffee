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

  SPEED = 100;

  positions = Positions.find({puzzleId: puzzle._id}).fetch()
  for p in positions
    p.block = puzzle.block(p.blockIndex)

  if false # disable heads for now
    heads = d3.select(template.find('.heads')).selectAll('.head').data(positions)
    heads.enter().append('div').attr('class','head').html("<img src='' />")
    heads.exit().remove()
    heads.select('img').attr('src', (d) -> Meteor.users.findOne(d.userId)?.profile?.picture or 'http://ts2.mm.bing.net/th?q=squirrel&w=50&h=50&c=1&pid=1.7&mkt=en-US&adlt=off&t=1')
    heads.transition().duration(SPEED)
      .style 'top', (d) -> findBlock(d.block.index).position().top + 'px'
      .style 'left', (d) -> findBlock(d.block.index).position().left + 'px'

  boxColor = d3.scale.category10()
  boxes = d3.select(template.find('.clueBoxes')).selectAll('.clueBox').data(positions)
  boxes.enter().append('div').attr('class','clueBox')
  boxes.exit().remove()
  boxes
    .style 'background-color', (d, i) -> boxColor(i)
    .each (d) ->
      clue = puzzle.clue(d.clueId)
      start = findBlock(clue?.start)
      end = findBlock(clue?.end)
      d3.select(@).transition().duration(SPEED).style
        'top': bounds(start).top + 'px'
        'left': bounds(start).left + 'px'
        'height': bounds(end).top - bounds(start).top + bounds(start).height + 1 + 'px'
        'width': bounds(end).left - bounds(start).left + bounds(start).width + 1 + 'px'

  inputs = d3.select(template.find('.inputs')).selectAll('.input').data(positions)
  inputs.enter().append('div').attr('class','input letter')
  inputs.exit().remove()
  inputs
    .style 'border-color', (d, i) -> boxColor(i)
    .transition().duration(SPEED)
    .style 'top', (d) -> bounds(findBlock(d.blockIndex)).top + 'px'
    .style 'left', (d) -> bounds(findBlock(d.blockIndex)).left + 'px'