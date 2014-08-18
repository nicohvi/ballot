class Poll

  constructor: (@el, json) ->
    @initBindings()
    @setupChart(json)

  initBindings: ->

  setupChart: (json)->
    ctx = document.getElementById('poll').getContext('2d')
    data = [
        value: 300
        color:"#F7464A"
        highlight: "#FF5A5E"
        label: "Red"
      ,
        value: 50
        color: "#46BFBD"
        highlight: "#5AD3D1"
        label: "Green"
      ,
        value: 100
        color: "#FDB45C"
        highlight: "#FFC870"
        label: "Yellow"
    ]

    options =
      responsive: true

    @chart = new Chart(ctx).Doughnut(data, options)


@Poll = Poll
