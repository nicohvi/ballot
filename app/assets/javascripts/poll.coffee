$ ->

  $nameInput = $('#poll-name')
  $poll = $('#poll')
  $spinner = $('.spinner')

  $(@).on 'keydown', (event) ->
    if event.which == 13
      $spinner.show()
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
      ).done( -> $spinner.hide())
