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


# Streams
$('.user-data ul a').asEventStream('click')
  .doAction (event) -> 
    $('.active').removeClass('active')
    $(event.target).parents('li').addClass('active')
  .onValue -> $container.spinner()

pollStream = $('.js-user-polls').asEventStream('ajax:success', (event, data, status, xhr) -> data)
voteStream = $('.js-user-votes').asEventStream('ajax:success', (event, data, status, xhr) -> data)

pollStream.merge(voteStream).onValue (html) -> 
  $container.html(html)
  $('i').tipsy()

showChartClicks = $(document).asEventStream('click', '.poll .js-show-chart')
  .debounceImmediate(1000)
  .doAction (event) ->
    event.preventDefault()
    $(event.target).toggleText('Show', 'Hide')
  .map      (event) ->  $(event.target).parents('.poll:first')


# subscribers
showChartClicks
  .filter   (poll) -> poll.find('.canvas-container').is(':visible')
  .onValue  (poll) -> poll.find('.canvas-container').hide()

showChartClicks
  .filter   (poll) -> !poll.find('canvas').is(':visible')
  .map      (poll) -> "/polls/#{poll.data('id')}"
  .flatMap(resolve)
  .onValue  (data) -> setupCanvas(data)
