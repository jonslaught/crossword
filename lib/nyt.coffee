
@downloadPuzzle = (date) ->

  url = "http://www.nytimes.com/svc/crosswords/v2/puzzle/daily-#{ date }.json"

  # Won't get full data because it doesn't have the auth :(
  if Meteor.isServer
    response = HTTP.get(url)
    parsePuzzle(response.data)

  # Won't work because it's a cross-origin request :(
  if Meteor.isClient
    $.getJSON url, (response) ->
      parsePuzzle(response)

# Only gets the metadata, not the content
@downloadPuzzles = (limit) ->
  limit ?= 100
  url = "http://www.nytimes.com/svc/crosswords/v2/puzzles.json?limit=#{ limit }&order=print_date&publish_type=daily"
  response = HTTP.get(url)
  for result in response.data.results
    p = parsePuzzleMeta(result)
    Puzzles.insert p    

@parsePuzzleMeta = (result) ->
  meta = result.puzzle_meta
  return {
    nyt_id: result.puzzle_id
    nyt_date: meta.printDate
    title: meta.title
    authors: meta.authors or [meta.author]
    editor: meta.editor
    day: ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"][meta.printDotw]
    height: meta.height
    width: meta.width
    note: meta.notes[0]?.txt
  }

@parsePuzzle = (response) ->

  result = response.results[0]
  p = parsePuzzleMeta(result)
  data = result.puzzle_data

  # Build up grid and answers
  p.grid = []
  p.coordinates = []

  i = 0
  for y in [0...p.height]
    p.grid[y] = []
    for x in [0...p.width]
      p.grid[y][x] = {
        white: data.layout[i] == 1
        answer: data.answers[i]
        index: i
        x: x
        y: y
      }
      p.coordinates[i] = {'x': x, 'y': y}
      i++

  # Parse clues
  clue = (c, direction) ->
    {
      direction: direction
      start: c.clueStart
      end: c.clueEnd
      number: c.clueNum
      text: c.value
      _id: c.clueNum + direction
    }

  p.clues = (clue(c, ACROSS) for c in data.clues.A).concat (clue(c, DOWN) for c in data.clues.D)

  # Attach clues to grid

  for clue in p.clues
    start = p.coordinates[clue.start]
    end = p.coordinates[clue.end]
    if clue.direction == ACROSS
      y = start.y
      for x in [ start.x .. end.x ]
        p.grid[y][x].clueAcross = clue

    if clue.direction == DOWN
      x = start.x
      for y in [ start.y .. end.y ]
        p.grid[y][x].clueDown = clue

    p.grid[start.y][start.x].clueNumber = clue.number

  # Insert the puzzle and return it
  Puzzles.upsert {nyt_id: p.nyt_id}, p