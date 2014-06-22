
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

@showPositions = (template, puzzle) ->

  positions = Positions.find
    puzzleId: puzzle._id
    userId: 
        $ne:
          Meteor.userId()
  .fetch()

  for p in positions
    p.block = puzzle.block(p.blockIndex)

  heads = d3.select(template.find('.positions'))
    .selectAll('.head')
    .data(positions)

  heads.enter()
    .append('div')
    .attr('class','head')
    .html((d) -> Template.position())

  heads.exit()
    .remove()

  heads.select('img')
    .attr 'src', (d) ->
      if user = Meteor.users.findOne(d.userId)
        picture = user.profile.picture
      else
        picture = 'http://ts2.mm.bing.net/th?q=squirrel&w=50&h=50&c=1&pid=1.7&mkt=en-US&adlt=off&t=1'

  heads.transition().duration(500).ease('cubic-out')
    .style 'top', (d) -> 
      return findBlock(d.block.index).position().top + 'px'
    .style 'left', (d) -> 
      return findBlock(d.block.index).position().left + 'px'