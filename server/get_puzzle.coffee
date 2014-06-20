@rows = []
@pointers = []

createGrid = (puzzle) ->

  meta = puzzle.results[0].puzzle_meta
  data = puzzle.results[0].puzzle_data

  height = meta.height
  width = meta.width

  i = 0
  for x in [0...width]
    rows[x] = []
    for y in [0...height]
      rows[x][y] = {
        block: data.layout[i] == 1
        answer: data.answers[i]
        index: i
      }
      pointers[i] = {'x': x, 'y': y}
      i++

  return Puzzles.insert
    rows: rows

Meteor.startup ->
  Puzzles.remove({})
  createGrid(wed)