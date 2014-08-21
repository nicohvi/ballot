class App

  constructor: (@el) ->
    @auth = new Auth()
    @initBindings()

  initBindings: ->

    @el.on 'auth', =>
      if @poll? then @auth.login(@poll.id) else @auth.login()

    @el.on 'header', =>
      @tipsy()

    @el.on 'poll:new', =>
      @unBind()
      @tipsy()
      @initFormBindings()

    @el.on 'poll:edit', =>
      @unBind()
      @tipsy()
      @pollEditor = new PollEditor($('#poll-edit'))

    @el.on 'poll:show', =>
      @unBind()
      @tipsy()
      Q( $.ajax
            url: "/polls/#{@el.find('#poll-container').data('id')}"
            dataType: 'json'
      )
      .then( (json) => @poll = new Poll($('#poll-container'), json)).done()

    @el.on 'login', =>
      @getPoll() if @poll?

    @el.on 'logout', =>
      if @poll?
        @getPoll()
        @updateHistory "/polls/#{@poll.id}", 'show'
      else
        @getPollForm()
        @updateHistory '/', 'new'

    $(window).on 'popstate', (event) =>
      state = event.originalEvent.state
      if state?
        switch state.action
          when 'new' then @getPollForm()
          when 'edit' then @getPollOptions()
          else @getPollForm()
      else
        @updateHistory('/')
        @getPollForm()
        @auth.getHeader()

  tipsy: ->
    $('.tipsy').remove()
    $('i').tipsy gravity: 'n'

  getPollForm: ->
    Q( $.get '/polls/new' ).then( (html) => @el.html(html)).done()

  getPoll: ->
    Q( $.get "/polls/#{@poll.id}" ).then( (html) => @el.html(html)).done()

  getPollOptions: ->
    Q( $.get "/polls/#{@pollEditor.id}/edit" ).then( (html) => @el.html(html)).done()

  initFormBindings: ->
    @nameInput = $('#poll-name')

    $(document).on 'keydown', (event) =>
      if event.which == 13
        @savePoll()
      else @nameInput.focus()

  unBind: ->
    $(document).off 'keydown'

  savePoll: ->
    $('.notice').remove()
    Q( $.post '/polls',
         poll:
           name: @nameInput.val()
      ).then(
        (html) =>
            @el.html(html)

            pollId = @el.find('#poll-edit').data('id')
            @updateHistory "/polls/#{pollId}/edit", 'edit'
            @auth.getHeader(pollId)
        ,
        (jqXHR, status, errorThrown) =>
          errorJSON = jqXHR.responseJSON.errors
          # Rails adds error messages as an array.
          if errorJSON['name']? then error = errorJSON['name'][0] else error = errorJSON
          $('<div>')
            .addClass('notice error')
            .text(error)
            .appendTo(@el)
      ).done()

  updateHistory: (url, action) ->
    history.pushState action: action, null, url

@App = App
