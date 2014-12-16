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
    Bacon.fromPromise $.getJSON $link.attr('href')
  .onValue (json) ->
    html = HandlebarsTemplates['polls'](json)
    updatePolls(createdPolls, html)

pollClicks
  .filter ($link) -> $link.parents('.voted-polls').length > 0
  .flatMap ($link) ->
    Bacon.fromPromise $.getJSON $link.attr('href')
  .onValue (html) ->
    html = HandlebarsTemplates['polls'](json)
    updatePolls votedPolls, html

$(document).asEventStream 'ajax:complete', '.delete-poll'
  .onValue (event) -> location.reload()

