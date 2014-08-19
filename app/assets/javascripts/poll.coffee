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
    Q( $.post "/polls/#{@id}/options/#{optionId}/vote")
    .then(
      (poll) => @setupChart(poll)
      ,
      (jqXHR, status, errorThrown) =>
        error = jqXHR.responseJSON.error
        $('<div>')
          .addClass('notice error')
          .text(error) # Rails adds error messages as an array.
          .appendTo(@el)
    ).done()

@Poll = Poll
