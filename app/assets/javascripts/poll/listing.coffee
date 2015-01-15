# variables
createdPolls  = $('.created-polls .polls')
votedPolls    = $('.voted-polls .polls')

# functions
updatePolls = (poll, html) ->
  Bacon.once poll.addClass('transition')
  .delay(800)
  .onValue -> 
    poll.html(html).removeClass 'transition'
    poll.find('i').tipsy { gravity: 'n' }

# streams

paginationClicks = $(document).asEventStream('click', '.pagination a')

pollsHTML = paginationClicks
  .doAction (event) -> event.preventDefault()
  .map (event) -> $(event.target).attr('href')
  .flatMap (url) -> Bacon.fromPromise $.get(url)

# subscribers

pollsHTML
  .filter (html) -> $(html).find('.delete-poll').length > 0
  .onValue (html) -> updatePolls(createdPolls, html)

pollsHTML
  .filter (html) -> !$(html).find('.delete-poll').length > 0
  .onValue (html) -> updatePolls votedPolls, html


