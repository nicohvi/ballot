# variables
poll = $('#poll').data('id')

# streams
voteRequests = $('.option').asEventStream 'click'
  .filter (event) -> $(event.target).data('id')?
  .map (event) ->
    id = $(event.target).data('id')
    "/polls/#{poll}/options/#{id}/vote"

voteResponses = voteRequests
  .flatMap (url) -> Bacon.fromPromise $.post(url)

pollResponses = voteResponses.startWith ''
  .flatMap -> Bacon.fromPromise $.getJSON "/polls/#{poll}"

voteResponses.onValue (json) -> debugger

pollResponses.onValue (poll) -> debugger
