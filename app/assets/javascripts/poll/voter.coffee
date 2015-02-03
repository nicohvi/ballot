# variables
pollId  = $('#poll').data('id')
ctx     = $('#poll')[0].getContext('2d')

colors  = [
    colorName:  'red'
    color:      '#E96950'
    highlight:  '#B35340'
  ,
    colorName:  'green'
    color:      '#42b983'
    highlight:  '#359368'
  ,
    colorName:  'yellow'
    color:      '#ffc870'
    highlight:  '#fdb45c'
  ,
    colorName:  'blue'
    color:      '#6189a1'
    highlight:  '#517083'
  ]

# functions
updatePoll = (data) ->
  new Chart(ctx).Doughnut(data, responsive: true)

showPoll = ->
  $('.no-votes').remove()
  $('#poll').removeClass('hidden')

repeatedly = (arr) ->
  i = 0
  ->
    i = 0 if i >= arr.length
    arr[i++]

setOptions = (options) ->
  repeater = repeatedly(colors)
  _.map options, (option) -> _.assign(option, repeater())

# streams
voteIds = $('.option').asEventStream 'click'
  .filter (event) -> $(event.target).data('id')?
  .map (event) ->
    id = $(event.target).data('id')

voteURLs = voteIds
  .filter -> !$.exists('.closed')
  .map (id) ->
    "/polls/#{pollId}/options/#{id}/vote"

voteResponses = voteURLs
  .flatMap (url) -> Bacon.fromPromise $.post(url)

pollResponse = Bacon.once("/polls/#{pollId}")
  .flatMap (url)  -> Bacon.fromPromise $.getJSON(url)
  .onValue (json) ->
    data = setOptions(json.options)
    updatePoll(data)
    color = _.find(data, (option) -> option.id == $('.voted').data('id'))
    $('.voted').addClass(color.colorName) if color?

# subscribers
voteResponses
  .map (json) ->
    showPoll() unless $('canvas').is('visible')
    data = setOptions(json.options)
    updatePoll(data)
    _.find(data, (option) -> option.id == json.vote)
  .onValue (option) ->
    $('.voted').removeClass "voted"
    $(".option[data-id=#{option.id}]").addClass "voted #{option.colorName}"

