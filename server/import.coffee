@rows = []
@coordinates = []

puzzleFromJSON = (json) ->

  meta = json.results[0].puzzle_meta
  data = json.results[0].puzzle_data

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
    start = coordinates[clue.start]
    end = coordinates[clue.end]
    if clue.direction == ACROSS
      y = start.y
      for x in [ start.x .. end.x ]
        rows[y][x].clueAcross = clue

    if clue.direction == DOWN
      x = coordinates[clue.start].x
      for y in [ start.y .. end.y ]
        rows[y][x].clueDown = clue

    rows[start.y][start.x].clueNumber = clue.number

  return Puzzles.insert
    coordinates: coordinates
    grid: rows
    height: height
    width: width
    clues: clues

reset = ->
  Guesses.remove({})
  Puzzles.remove({})
  Positions.remove({})

Meteor.startup ->
  
  createGrid(wed_6_25)