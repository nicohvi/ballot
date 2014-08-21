class Poll

  constructor: (@el) ->
    @COLORS = [
        name: 'red'
        normal: '#ff6f5f'
        highlight: '#ff5a5e'
      ,
        name: 'green'
        normal: '#42b983'
        highlight: '#599b7d'
      ,
        name: 'yellow'
        normal: '#ffc870'
        highlight: '#fdb45c'
    ]
    @voting = false

    @loadPoll()
    @initBindings()

  loadPoll: ->
    Q( $.ajax
          url: "/polls/#{app.pollId}"
          dataType: 'json'
    )
    .then( (poll) => @setupChart(poll) ).done()

  initBindings: ->
    $('.option').on 'click', (event) =>
      @vote $(event.target).data('id')

  setupChart: (poll) ->
    ctx = document.getElementById('poll').getContext('2d')
    data = []

    colorIndex = 0
    for option in poll.options
      color = @COLORS[colorIndex].name
      data.push {
        value: option.votes.length
        color: @COLORS[colorIndex].normal
        highlight: @COLORS[colorIndex].highlight
        label: option.name
      }

      # Add colors to the option DOM elements
      $(".option[data-id=#{option.id}]").addClass(color)

      colorIndex++
      colorIndex = 0 if colorIndex > 2

    options =
      responsive: true

    @chart = new Chart(ctx).Doughnut(data, options)

  vote: (optionId) ->
    $('.notice').remove()
    return @addError('You have to log in to vote, dawg.') unless app.loggedIn
    return false if @voting
    @voting = true
    Q( $.post "/polls/#{app.pollId}/options/#{optionId}/vote")
    .then(
      (poll) =>
        @setupChart(poll)
        $('.voted').removeClass('voted')
        $(".option[data-id=#{optionId}]").addClass('voted')
        if poll.message?
          $('<div>')
            .addClass('notice')
            .text(poll.message)
            .appendTo(@el)
      ,
      (jqXHR, status, errorThrown) => @addError(jqXHR.responseJSON.error)
    ).done( => @voting = false )

  addError: (error) ->
    $('<div>')
      .addClass('notice error')
      .text(error)
      .appendTo(@el)

@Poll = Poll
