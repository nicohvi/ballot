# variables
$container  = $('.info-container')
chartCache  = {}

# functions
setupCanvas = (data) ->
  options = setOptions(data.options)
  $poll = $(".poll[data-id=#{data.slug}]")
  $poll.find('.canvas-container').show()
  ctx = $poll.find('canvas')[0].getContext('2d')
  new Chart(ctx).Doughnut(options, responsive: true)

setOptions = (options) ->
  repeater = repeatedly(colors)
  _.map options, (option) -> _.assign(option, repeater())

resolve = (url) ->
  return chartCache[url] if chartCache[url]?
  Bacon.fromPromise($.getJSON(url)).flatMap (json) -> chartCache[url] = json

load = -> $container.spinner()

# streams
pollAndVoteClicks = $('.js-user-polls, .js-user-votes').asEventStream('click')
  .map (event) -> $(event.target)

listClicks = pollAndVoteClicks
  .filter   ($link) -> $link.hasParent('ul')
  .doAction ($link) -> 
    $('.active').removeClass('active')
    $link.parents('li').addClass('active')

paragraphClicks = pollAndVoteClicks
  .filter   ($link) -> !$link.hasParent('ul')
  .doAction ($link) -> 
    $('.active').removeClass('active')
    $("li a[href='#{$link.attr('href')}']").parents('li').addClass('active')

paragraphClicks.merge(listClicks).onValue -> $container.spinner()

onLoad = Bacon.once $('.js-user-polls').attr('href')
  .doAction -> load()
  .flatMap (url) -> Bacon.fromPromise $.get(url)

pollStream = $('.js-user-polls').asEventStream('ajax:success', (event, data, status, xhr) -> data)
voteStream = $('.js-user-votes').asEventStream('ajax:success', (event, data, status, xhr) -> data)

toggleChartClicks = $(document).asEventStream('click', '.poll .js-toggle-chart')
  .debounceImmediate(1000)
  .doAction (event) -> event.preventDefault()
  .map      (event) ->  $(event.target).parents('.poll:first')

ajaxStream = $(document).asEventStream('click', '.pagination a')
   .doAction (event) -> event.preventDefault()
  .map (event) -> $(event.target).attr('href')
  .doAction -> $container.spinner()
  .flatMap (url) -> Bacon.fromPromise $.get(url)

# subscribers
Bacon.mergeAll(onLoad, pollStream, voteStream, ajaxStream).onValue (html) -> 
  $container.html(html)
  $('i').tipsy()

toggleChartClicks
  .filter   (poll) -> poll.find('.canvas-container').is(':visible')
  .onValue  (poll) -> 
    poll.find('.canvas-container').hide()
    poll.find('.js-toggle-chart').toggleText("Show", "Hide")

toggleChartClicks
  .filter   (poll) -> !poll.find('canvas').is(':visible')
  .map      (poll) -> "/polls/#{poll.data('id')}"
  .flatMap(resolve)
  .onValue  (data) -> 
    setupCanvas(data)
    $(".poll[data-id='#{data.slug}'] .js-toggle-chart").toggleText("Show", "Hide")

