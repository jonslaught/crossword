
Template.uploader.rendered = ->

  $('.date-picker').datepicker
    format: "yyyy-mm-dd",
    todayBtn: "linked",
    todayHighlight: true

  onChangeDate = ->
    $('.date-picker').datepicker('hide')
    date =  moment($('.date-picker input').val())
    url = "http://www.nytimes.com/svc/crosswords/v2/puzzle/daily-#{ date.format('YYYY-MM-DD') }.json"
    $('.nyt-json iframe').attr('src',url)

  $('.date-picker').on 'changeDate', onChangeDate

  onChangeDate()

Template.uploader.events
  'click .upload': ->
    response = JSON.parse $('.copied-json').val()
    p = parsePuzzle(response)
    Router.go('listing')

Template.listing.puzzles = ->
  Puzzles.find {},
    sort:
      nyt_date: -1

Template.listing_puzzle.date = ->
  @getDate()

###
Template.listing.events
  "click .play": ->

    # Create a room with that puzzle

    # Redirect to a URL pointing to that room
###

