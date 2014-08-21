class App

  constructor: (@el) ->
    @pollId = null
    @auth = new Auth()
    @initBindings()

  initBindings: ->
    @el.on 'auth', =>
      @auth.login()

    @el.on 'header', =>
      @tipsy()

    @el.on 'poll:new', =>
      return @getForm() unless $('#poll-form').length > 0 # Called from popstate
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

  getForm: ->
    Q( $.get '/polls/new' ).then( (html) => @el.html(html) ).done()

  getEditor: ->
    Q( $.get "/polls/#{@pollId}/edit" ).then( (html) => @el.html(html)).done()

@App = App
