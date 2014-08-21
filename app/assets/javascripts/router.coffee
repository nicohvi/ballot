class Router

  constructor: ->
    @history = []
    @initBindings()

  push: (entry) ->
    @history.push entry
    window.history.pushState { action: entry.action, url: entry.url }, null, entry.url

  initBindings: ->

    $(window).on 'popstate', (event) =>
      state = event.originalEvent.state
      switch state.action
        when 'new' then $('#main').trigger('poll:new')

@Router = Router
