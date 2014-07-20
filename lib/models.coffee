@ACROSS = 'A'
@DOWN = 'D'

@PEN = 'pen'
@PENCIL = 'pencil'

@Puzzles = new Meteor.Collection "puzzles",
  transform: (doc) ->
    return new Puzzle(doc)

@Guesses = new Meteor.Collection "guesses",
@Positions = new Meteor.Collection "positions"
@Clues = new Meteor.Collection "clues"

if Meteor.isServer
  Meteor.publish 'puzzle', (id) ->
    return [
      Puzzles.find(id),
      Guesses.find({puzzleId: id}),
      Positions.find({puzzleId: id})
      Clues.find({puzzleId: id})
    ]

  Meteor.publish 'puzzles', ->
    return Puzzles.find()