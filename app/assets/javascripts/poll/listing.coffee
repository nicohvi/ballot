# variables
$container = $('.info-container')

# functions
setupCanvas = (data) ->
  options = setOptions(data.options) 
  $poll = $(".poll[data-id=#{data.slug}]")
  $poll.find('.canvas-container').show()
  ctx = $poll.find('canvas')[0].getContext('2d')
  new Chart(ctx).Doughnut(options, responsive: true)
  $poll.find('.js-show-canvas').remove()

setOptions = (options) ->
  repeater = repeatedly(colors)
  _.map options, (option) -> _.assign(option, repeater())

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

$(document).asEventStream('click', '.poll .js-show-canvas')
  .debounceImmediate(1000)
  .doAction (event) -> event.preventDefault()
  .map (event) -> $(event.target).parents('.poll:first').data('id')
  .flatMap (id) -> Bacon.fromPromise $.getJSON ("/polls/#{id}")
  .onValue (data) -> setupCanvas(data)
