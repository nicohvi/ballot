class Poll

  constructor: (@el, json) ->
    @initBindings()
    @setupChart(json)

  initBindings: ->

  setupChart: (json)->
    ctx = document.getElementById('poll').getContext('2d')
    labels = []
    datasets = []

    for option in json.options
      labels.push option.name

    set1 =
      label: "My First dataset",
      fillColor: "rgba(220,220,220,0.5)",
      strokeColor: "rgba(220,220,220,0.8)",
      highlightFill: "rgba(220,220,220,0.75)",
      highlightStroke: "rgba(220,220,220,1)",
      data: [65, 2]

    datasets.push set1

    data =
      labels: labels
      datasets: datasets

    @chart = new Chart(ctx).Bar(data)


@Poll = Poll
