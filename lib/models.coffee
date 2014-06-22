@Puzzles = new Meteor.Collection "puzzles",
  transform: (doc) ->
    return new Puzzle(doc)

@Guesses = new Meteor.Collection "guesses",
  transform: (doc) ->
    return new Guess(doc)  

@Positions = new Meteor.Collection "positions"

class @Puzzle
  constructor: (doc) ->
    _.extend(@, doc)

  block: (xOrIndex, y) ->
    if y?
      x = xOrIndex
      return @grid[y][x]
    else
      index = xOrIndex
      return @block(@coordinates[index].x, @coordinates[index].y)

class @Guess

  constructor: (doc) ->
    _.extend(@, doc)

