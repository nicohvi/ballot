#paginationClicks = $(document).asEventStream('click', '.pagination a')

#pollsHTML = paginationClicks
  #.doAction (event) -> event.preventDefault()
  #.map (event) -> $(event.target).attr('href')
  #.flatMap (url) -> Bacon.fromPromise $.get(url)

#pollsHTML
  #.filter (html) -> $(html).find('.delete-poll').length > 0
  #.onValue (html) -> updatePolls(createdPolls, html)

#pollsHTML
  #.filter (html) -> !$(html).find('.delete-poll').length > 0
  #.onValue (html) -> updatePolls votedPolls, html
$container = $('.info-container')

# Streams
$('.user-data ul a').asEventStream('click')
  .doAction (event) -> 
    $('.active').removeClass('active')
    $(event.target).parents('li').addClass('active')
  .onValue -> $container.spinner()

pollStream = $('.js-user-polls').asEventStream('ajax:success', (event, data, status, xhr) -> data)
voteStream = $('.js-user-votes').asEventStream('ajax:success', (event, data, status, xhr) -> data)

pollStream.merge(voteStream).onValue (html) -> $container.html(html)

#variable
#createdPolls  = $('.created-polls .polls')
#votedPolls    = $('.voted-polls .polls')

 #functions
#updatePolls = (poll, html) ->
  #Bacon.once poll.addClass('transition')
  #.delay(800)
  #.onValue -> 
    #poll.html(html).removeClass 'transition'
    #poll.find('i').tipsy { gravity: 'n' }

 #streams

#paginationClicks = $(document).asEventStream('click', '.pagination a')

#pollsHTML = paginationClicks
  #.doAction (event) -> event.preventDefault()
  #.map (event) -> $(event.target).attr('href')
  #.flatMap (url) -> Bacon.fromPromise $.get(url)

 #subscribers

#pollsHTML
  #.filter (html) -> $(html).find('.delete-poll').length > 0
  #.onValue (html) -> updatePolls(createdPolls, html)

#pollsHTML
  #.filter (html) -> !$(html).find('.delete-poll').length > 0
  #.onValue (html) -> updatePolls votedPolls, html


