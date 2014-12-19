# variables
pollId  = $('#poll').data('id')
ctx     = $('#poll canvas')[0].getContext('2d')

colors  = [
    colorName:  'red'
    color:      '#ff6f5f'
    highlight:  '#ff5a5e'
  ,
    colorName:  'green'
    color:      '#42b983'
    highlight:  '#599b7d'
  ,
    colorName:  'yellow'
    color:      '#ffc870'
    highlight:  '#fdb45c'
  ]

# functions
updatePoll = (data) ->
  new Chart(ctx).Doughnut(data, responsive: true)

showPoll = ->
  $('.empty').remove()
  $('canvas').removeClass('none')

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
  .map (id) ->
    "/polls/#{pollId}/options/#{id}/vote"

voteResponses = voteURLs
  .flatMap (url) -> Bacon.fromPromise $.post(url)

pollResponse = Bacon.once("/polls/#{pollId}")
  .flatMap (url) -> Bacon.fromPromise $.getJSON(url)

pollData = voteResponses.merge(pollResponse)
  .filter (json) -> json.options.length > 0
  .map (json) ->
    options: setOptions(json.options)
    vote:    json.voted_for

# subscribers
pollData
  .map (json) -> json.options
  .onValue (options) -> updatePoll(options)

pollData
  .filter (json) -> json.vote?
  .map (json) ->
    _.find(json.options, (option) -> option.id == json.vote)
  .onValue (option) ->
    showPoll() unless $('canvas').is('visible')
    $('.voted').removeClass "voted"
    $(".option[data-id=#{option.id}]").addClass "voted #{option.colorName}"

