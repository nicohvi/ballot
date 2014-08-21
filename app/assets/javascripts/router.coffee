class Router

  constructor: (@target) ->

  form: ->
    Q( $.get '/polls/new' ).then( (html) => @target.html(html) ).done()

  editor: ->
    Q( $.get "/polls/#{app.pollId}/edit" ).then( (html) => @target.html(html)).done()

  poll: ->
    Q( $.get "/polls/#{app.pollId}" ).then( (html) => @target.html(html)).done()


@Router = Router
