# variables
createdPolls  = $('.created-polls .polls')
votedPolls    = $('.voted-polls .polls')

# functions
updatePolls = (poll, html) ->
  Bacon.once poll.addClass('transition')
  .delay(800)
  .onValue -> poll.html(html).removeClass 'transition'

# streams
pollClicks = $(document).asEventStream('click', '.next_page, .previous_page')
  .doAction (event) -> event.preventDefault()
  .filter (event) -> !$(event.target).hasClass('disabled')
  .map (event) -> $(event.target)

pollClicks
  .filter ($link) -> $link.parents('.created-polls').length > 0
  .flatMap ($link) ->
    Bacon.fromPromise $.get $link.attr('href')
  .onValue (html) ->
    updatePolls createdPolls, $(html).find('.polls')[0]

pollClicks
  .filter ($link) -> $link.parents('.voted-polls').length > 0
  .flatMap ($link) ->
    Bacon.fromPromise $.get $link.attr('href')
  .onValue (html) ->
    updatePolls votedPolls, $(html).find('.polls')[1]


