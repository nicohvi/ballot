class Poll

  constructor: (@el, poll) ->
    @id = poll.slug
    @initBindings()
    @COLORS = [
        normal: '#ff6f5f'
        highlight: '#ff5a5e'
      ,
        normal: '#42b983'
        highlight: '#599b7d'
      ,
        normal: '#ffc870'
        highlight: '#fdb45c'
    ]
    @setupChart(poll)

  initBindings: ->
    $('.option').on 'click', (event) =>
      @vote $(event.target).data('id')

  setupChart: (poll) ->
    ctx = document.getElementById('poll').getContext('2d')
    data = []

    colorIndex = 0
    for option in poll.options
      data.push {
        value: option.votes.length
        color: @COLORS[colorIndex].normal
        highlight: @COLORS[colorIndex].highlight
        label: option.name
      }
      colorIndex++
      colorIndex = 0 if colorIndex > 2

    options =
      responsive: true

    @chart = new Chart(ctx).Doughnut(data, options)

  vote: (optionId) ->
    $('.notice').remove()
    return @addError('You have to log in to vote, dawg.') unless $('.current-user').length > 0
    Q( $.post "/polls/#{@id}/options/#{optionId}/vote")
    .then(
      (poll) =>
        @setupChart(poll)
        $(".option[data-id=#{optionId}]").addClass('voted')
      ,
      (jqXHR, status, errorThrown) => @addError(jqXHR.responseJSON.error)
    ).done()

  addError: (error) ->
    $('<div>')
      .addClass('notice error')
      .text(error)
      .appendTo(@el)

@Poll = Poll
