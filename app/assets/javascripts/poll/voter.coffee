# variables
pollId  = $('.poll-container').data('id')

# functions
setupCanvas = (data) ->
  ctx = $('#poll')[0].getContext('2d')
  new Chart(ctx).Doughnut(data, responsive: true)
  showPoll()

showPoll = ->
  $('.no-votes').remove()
  $('#poll').removeClass('hidden')

setVote = (option) ->
  $('.voted').removeClass "voted"
  $(".option[data-id=#{option.id}]").addClass "voted #{option.colorName}"

# Matches each option from the server with a corresponding
# color.
setOptions = (options) ->
  repeater = repeatedly(colors)
  _.map options, (option) -> _.assign(option, repeater())

# streams
Bacon.once("/polls/#{pollId}")
  .flatMap (url)  -> Bacon.fromPromise $.getJSON(url)
  .map (json) -> setOptions(json.options)
  .doAction (data) ->
    color = _.find(data, (option) -> option.id == $('.voted').data('id'))
    $('.voted').addClass(color.colorName) if color?
  .filter -> $.exists('#poll')
  .onValue (data) -> setupCanvas(data)
  

pollResponse = $('.option').asEventStream('click')
  .filter (event) -> $(event.target).data('id')?
  .map (event) -> id = $(event.target).data('id')
  .filter -> !$.exists('.closed')
  .map (id) -> "/polls/#{pollId}/options/#{id}/vote"
  .flatMap (url) -> Bacon.fromPromise $.post(url)

# subscribers

pollResponse
  .map (json) -> 
    _.find(setOptions(json.options), (option) -> option.id == json.vote)
  .onValue (option) -> setVote(option)

pollResponse
  .filter -> $.exists('#poll')
  .map (json) -> setOptions(json.options)
  .onValue (data) -> setupCanvas(data)
  
