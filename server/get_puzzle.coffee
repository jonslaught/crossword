@rows = []
@coordinates = []

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
        x: x
        y: y
      }
      coordinates[i] = {'x': x, 'y': y}
      i++

  clues = []

  for clue in data.clues.A
    clue.direction = "A"
    clue.id = clue.clueNum + clue.direction
    clues.push(clue)

  for clue in data.clues.D
    clue.direction = "A"
    clue.id = clue.clueNum + clue.direction
    clues.push(clue)

  for clue in clues
    c = coordinates[clue.clueStart]
    rows[c.x][c.y].clue = clue.clueNum 


  return Puzzles.insert
    rows: rows

Meteor.startup ->
  Puzzles.remove({})
  createGrid(wed)