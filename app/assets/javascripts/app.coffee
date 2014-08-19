class App

  constructor: (@el) ->
    @initBindings()
    @auth = new Auth()

  initBindings: ->
    @el.on 'poll:new', =>
      @unBind()
      @initFormBindings()

    @el.on 'poll:edit', (event, data) =>
      @unBind()
      @pollEditor = new PollEditor($('#poll-edit'))

    @el.on 'poll:show', (event, data) =>
      Q( $.ajax
            url: "/polls/#{data.id}"
            dataType: 'json'
      )
      .then( (json) => @poll = new Poll($('#poll-container'), json)).done()

    $(window).on 'popstate', (event) =>
      state = event.originalEvent.state
      @getPollForm() unless state?

  getPollForm: ->
    Q( $.get '/polls/new' ).then( (html) => @el.html(html)).done()

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
    @nameInput.addClass('disabled')
    Q( $.post '/polls',
         poll:
           name: @nameInput.val()
      ).then(
        (html) =>
            @el.html(html)
            @updateHistory "/polls/#{@el.find('#poll-edit').data('id')}/edit", 'edit'
        ,
        (jqXHR, status, errorThrown) =>
          errors = jqXHR.responseJSON.errors
          $('<div>')
            .addClass('notice error')
            .text(errors['name'][0]) # Rails adds error messages as an array.
            .appendTo(@el)
          @nameInput.addClass('error')
      ).done( => @nameInput.removeClass('disabled'))

  updateHistory: (url, action) ->
    history.pushState action: action, null, url

@App = App
