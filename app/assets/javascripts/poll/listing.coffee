# variables
createdPolls  = $('.created-polls .polls')
votedPolls    = $('.voted-polls .polls')
nextPage      = $('.next_page')
prevPage      = $('.previous_page')
pageLinks     = $('.pagination a:not(.next_page):not(.previous_page), .pagination em')

# functions
updatePagination = (previous) ->
  url = nextPage.attr('href').slice(0,-1)

getUrl = ($link) ->
  $link.attr('href').slice(0,-1)

updatePolls = (poll, html) ->
  Bacon.once poll.addClass('transition')
  .delay(800)
  .onValue ->
    poll.html(html).removeClass 'transition'
    poll.find('i').tipsy { gravity: 'n' }

# streams
nextClicks      = nextPage.asEventStream('click')
previousClicks  = prevPage.asEventStream('click')
pageLinkClicks  = pageLinks.asEventStream('click')

createdPollsRequests = Bacon.mergeAll(nextClicks, previousClicks, pageLinkClicks)
  .filter (event) -> $(event.target).hasParent('.created-polls')

votedPollsRequests = Bacon.mergeAll(nextClicks, previousClicks, pageLinkClicks)
  .filter (event) -> $(event.target).hasParent('.voted-polls')

pollsJSON = createdPollsRequests.merge(votedPollsRequests)
  .doAction (event) -> event.preventDefault()
  .map (event) -> $(event.target)
  .flatMap ($link) -> Bacon.fromPromise $.getJSON $link.attr('href')
 
pollsJSON
  .filter (json) -> json.created
  .onValue (json) ->
    html = HandlebarsTemplates['polls'](json)
    updatePolls(createdPolls, html)
    #updatePagination(json.page)

pollsJSON
  .filter (json) -> !json.created
  .onValue (json) ->
    html = HandlebarsTemplates['polls'](json)
    updatePolls votedPolls, html


