# variables
#createdPolls  = $('.created-polls .polls')
#votedPolls    = $('.voted-polls .polls')
#nextPage      = $('.next_page')
#prevPage      = $('.previous_page')

## functions
#updatePagination = (previous) ->
  #url = nextPage.attr('href').slice(0,-1)

#getUrl = ($link) ->
  #debugger
  #$link.attr('href').slice(0,-1)

#updatePolls = (poll, html) ->
  #Bacon.once poll.addClass('transition')
  #.delay(800)
  #.onValue -> poll.html(html).removeClass 'transition'

## streams
#pollStream = $(document).asEventStream('click', '.next_page, .previous_page')
  #.doAction (event) -> event.preventDefault()
  #.filter (event) -> !$(event.target).hasClass('disabled')
  #.map (event) -> $(event.target)
  #.flatMap ($link) ->
    #Bacon.fromPromise $.getJSON $link.attr('href')
  
#pollStream
  #.filter (json) -> json.created?
  #.onValue (json) ->
    #html = HandlebarsTemplates['polls'](json)
    #updatePolls(createdPolls, html)
    #updatePagination(json.page)

#pollStream
  #.filter (json) -> !json.created?
  #.onValue (json) ->
    #html = HandlebarsTemplates['polls'](json)
    #updatePolls votedPolls, html

#$(document).asEventStream 'ajax:complete', '.delete-poll'
  #.onValue (event) -> location.reload()

