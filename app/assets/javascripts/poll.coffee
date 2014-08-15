$ ->

  $nameInput = $('#poll-name')
  $poll = $('#poll')

  $(@).on 'keydown', (event) ->
    if event.which == 13
      Q( $.post '/polls',
           poll:
             name: $nameInput.val()
      ).then(
        (html) -> $poll.html(html),
        (jqXHR, status, errorThrown) ->
          errors = jqXHR.responseJSON.errors
          $('<div>')
            .addClass('notice error')
            .text(errors['name'][0]) # Rails adds error messages as an array.
            .appendTo($poll)
          $nameInput.addClass('error')
      )
