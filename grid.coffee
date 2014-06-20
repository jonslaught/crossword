

createGrid = (puzzle) ->
  height = puzzle.results.height
  width = puzzle.results.width

  guesses = []
  blocks = []
  answers = []
  pointers = []

  i = 0
  for x in [0..width]
    guesses[x] = []
    blocks[x] = []
    answers[x] = []
    for y in [0..height]
      guesses[x][y] = ""
      blocks[x][y] = puzzle.results.puzzleData.layout[i]
      answers[x][y] = puzzle.results.puzzleData.answers[i]
      pointers[i] = {'x': x, 'y': y}
      i++


