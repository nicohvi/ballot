class App

  constructor: (@el) ->
    @pollId = null
    if $('.current-user').length > 0 then @loggedIn = true else @loggedIn = false
    @auth = new Auth()
    @router = new Router(@el)
    @initBindings()

  initBindings: ->
    @el.on 'auth', =>
      @loggedIn = true
      @auth.updateHeader()
      $('.notice').remove()
      @router.poll() if @poll

    @el.on 'header', =>
      @tipsy()

    @el.on 'poll:new', =>
      @pollId = null # we now operate on a new poll, lets forget the old one, shall we?
      return @router.form() unless $('#poll-form').length > 0 # Called from popstate
      @form = new PollForm($('#poll-form'))
      @auth.updateHeader()

    @el.on 'poll:edit', (event, data) =>
      return @router.editor(data.id) if data.load? # Called through popstate

      if data.html? # the form was added through an AJAX call
        @el.html(data.html)
        @auth.updateHeader()
        id = $('#poll-edit').data('id')
        window.history.pushState { action: 'edit', id: id }, null, "/polls/#{id}/edit"
      else # only add the poll-editor once the DOM has loaded.
        @pollId = data.id
        @pollEditor = new PollEditor($('#poll-edit'))

    @el.on 'poll:show', (event, data) =>
      @pollId = data.id
      @poll = new Poll($('#poll-container'))

    @el.on 'user', =>
      @user = new User()

    # If the history entry has a state it was manually added, otherwise we
    # load the root page.
    $(window).on 'popstate', (event) =>
      state = event.originalEvent.state
      if state? && state.action? then $('#main').trigger('poll:edit', { id: state.id, load: true }) else $('#main').trigger('poll:new')
    
  unbind: ->
    $(document).off 'keydown'

  tipsy: ->
    $('.tipsy').remove()
    $('i').tipsy gravity: 'n'

@App = App
