class App

  constructor: (@el) ->
    @pollId = null
    @auth = new Auth()
    @router = new Router(@el)
    @initBindings()

  initBindings: ->
    @el.on 'auth', =>
      @auth.login()
      @router.poll() if @poll

    @el.on 'header', =>
      @tipsy()

    @el.on 'poll:new', =>
      return @router.form() unless $('#poll-form').length > 0 # Called from popstate
      @form = new PollForm($('#poll-form'))
      @auth.updateHeader()

    @el.on 'poll:edit', (event, data) =>
      return @getEditor() unless data? # Called through popstate
      @pollId = data.id

      if data.html? # the form was added through an AJAX call
        @el.html(data.html)
        @auth.updateHeader()
        window.history.pushState { action: 'edit' }, null, "/polls/#{@pollId}/edit"
      else # only add the poll-editor once the DOM has loaded.
        @pollEditor = new PollEditor($('#poll-edit'))

    @el.on 'poll:show', (event, data) =>
      @pollId = data.id
      @poll = new Poll($('#poll-container'))

    # If the history entry has a state it was manually added, otherwise we
    # load the root page.
    $(window).on 'popstate', (event) =>
      state = event.originalEvent.state
      if state && state.action? then $('#main').trigger('poll:edit') else $('#main').trigger('poll:new')

  unbind: ->
    $(document).off 'keydown'

  tipsy: ->
    $('.tipsy').remove()
    $('i').tipsy gravity: 'n'

@App = App
