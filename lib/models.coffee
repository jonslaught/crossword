@Puzzles = new Meteor.Collection "puzzles",
    transform: (doc) ->
      return new Puzzle(doc)

class @Puzzle
  constructor: (doc) ->
    _.extend(@, doc)

  block: (x, y) ->
    if y?
      return @grid[y][x]
    else
      [x, y] = @coordinates[x]
      return block(x, y)