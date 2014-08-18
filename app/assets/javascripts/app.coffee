class App

  constructor: (@el) ->
    @initBindings()

  initBindings: ->
    @el.on 'poll:new', =>
      @getPollForm() unless $('#poll-name').length > 0
      url = "/"
      history.pushState { url: url, state: 'new' }, null, url
      @initFormBindings()

    @el.on 'poll:show', (event, data) =>
      url = "/polls/#{data.id}"
      history.pushState { url: url, state: 'show' }, null, url

    @el.on 'poll:edit', (event, data) =>
      url = "/polls/#{data.id}/edit"
      history.pushState { url: url, state: 'show' }, null, url
      @pollManager = new PollManager($('#poll'))

  getPollForm: ->
    Q( $.get '/polls/new').then((html) => @el.html(html)).done()

  initFormBindings: ->
    @nameInput = $('#poll-name')

    $(document).on 'keydown', (event) =>
      if event.which == 13
        @savePoll()
      else @nameInput.focus()

  savePoll: ->
    $('.notice').remove()
    @nameInput.addClass('disabled')
    Q( $.post '/polls',
         poll:
           name: @nameInput.val()
      ).then(
        (html) => $(@el.html(html))
        ,
        (jqXHR, status, errorThrown) =>
          errors = jqXHR.responseJSON.errors
          $('<div>')
            .addClass('notice error')
            .text(errors['name'][0]) # Rails adds error messages as an array.
            .appendTo(@el)
          @nameInput.addClass('error')
      ).done( => @nameInput.removeClass('disabled'))

@App = App
