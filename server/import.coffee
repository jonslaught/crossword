reset = ->
  Guesses.remove({})
  Puzzles.remove({})
  Positions.remove({})

Meteor.startup ->
  
  #reset()
  if Puzzles.find().count() == 0
    downloadPuzzles(10)