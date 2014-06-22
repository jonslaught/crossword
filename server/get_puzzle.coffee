@rows = []
@coordinates = []

createGrid = (puzzle) ->

  meta = puzzle.results[0].puzzle_meta
  data = puzzle.results[0].puzzle_data

  height = meta.height
  width = meta.width

  i = 0
  for y in [0...height]
    rows[y] = []
    for x in [0...width]
      rows[y][x] = {
        white: data.layout[i] == 1
        answer: data.answers[i]
        index: i
        x: x
        y: y
      }
      coordinates[i] = {'x': x, 'y': y}
      i++

  clue = (c, direction) ->
    {
      direction: direction
      start: c.clueStart
      end: c.clueEnd
      number: c.clueNum
      text: c.value
      _id: c.clueNum + direction
    }


  clues = (clue(c, ACROSS) for c in data.clues.A).concat (clue(c, DOWN) for c in data.clues.D)

  for clue in clues
    c = coordinates[clue.start]
    rows[c.y][c.x].clue = clue.number

  return Puzzles.insert
    coordinates: coordinates
    grid: rows
    height: height
    width: width
    clues: clues

Meteor.startup ->
  Guesses.remove({})
  Puzzles.remove({})
  createGrid(wed)