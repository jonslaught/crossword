@Puzzles = new Meteor.Collection "puzzles",
  transform: (doc) ->
    return new Puzzle(doc)

@Guesses = new Meteor.Collection "guesses",
  transform: (doc) ->
    return new Guess(doc)  

class @Puzzle
  constructor: (doc) ->
    _.extend(@, doc)

  block: (x, y) ->
    if y?
      return @grid[y][x]
    else
      [x, y] = @coordinates[x]
      return block(x, y)

class @Guess

  ###  
  fields:
    user: "The user who did the guess"
    team: "The team they made it for"
    time: "When the guess"
    puzzle: "The puzzle it was for"
  ###

  constructor: (doc) ->
    _.extend(@, doc)

