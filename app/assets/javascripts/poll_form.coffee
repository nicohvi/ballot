class PollForm

  constructor: (@el) ->
    @nameInput = $('#poll-name')
    @initBindings()

  initBindings: ->
    app.unbind()

    $(document).on 'keydown', (event) =>
      if event.which == 13
        @savePoll()
      else @nameInput.focus()

  savePoll: ->
    $('.notice').remove()
    Q( $.post '/polls',
         poll:
           name: @nameInput.val()
      ).then(
        (html) =>
          $('#main').trigger 'poll:edit', { html: html }
        (jqXHR, status, errorThrown) =>
          errorJSON = jqXHR.responseJSON.errors
          # Rails adds error messages as an array.
          if errorJSON['name']? then error = errorJSON['name'][0] else error = errorJSON
          $('<div>')
            .addClass('notice error')
            .text(error)
            .appendTo(@el)
      ).done()


@PollForm = PollForm
