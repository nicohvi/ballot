# variables
pollId  = $('#poll').data('id')
poll    = $('#poll canvas')[0].getContext('2d')
colors  = [
    color:     '#ff6f5f'
    highlight:  '#ff5a5e'
  ,
    color:     '#42b983'
    highlight:  '#599b7d'
  ,
    color:     '#ffc870'
    highlight:  '#fdb45c'
  ]

# functions
updatePoll = (data) ->
  new Chart(poll).Doughnut(data, responsive: true)

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

pollData = voteResponses
  .merge(pollResponse)
  .map (json) -> _.merge colors, json.options

# subscribers
pollData.onValue (options) -> updatePoll(options)
pollResponse.flatMapLatest(voteIds)
  .onValue (voteId) ->
    $('.voted').removeClass 'voted'
    $(".option[data-id=#{voteId}]").addClass 'voted'

