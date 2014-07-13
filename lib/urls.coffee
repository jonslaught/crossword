Router.map ->
  this.route 'listing',
    template: 'listing'
    path: '/'

  this.route 'uploader',
    path: '/upload/:nyt_date?'
    data: -> @params

  this.route 'room',
    path: '/room/:_id'
    data: -> Rooms.findOne @params._id

  this.route 'puzzle',
    path: '/puzzle/:_id'
    onData: ->

      p = Puzzles.findOne(@params._id)
      Session.set('currentPuzzleId', p?._id)
      Session.set('currentClue', p?.clues[0])

    data: -> Puzzles.findOne @params._id

Router.configure
  layoutTemplate: 'master'