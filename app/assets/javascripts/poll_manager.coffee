class PollManager

  constructor: (@el) ->
    @options = $('#options')
    @addOption = $('#add-option')
    @initBindings()

  initBindings: ->
    @addOption.on 'click', (event) =>
      event.preventDefault()
      Q( $.get @addOption.attr('href') )
        .then(
          (html) =>
            $(html).insertBefore(@addOption)
            @addOptionHandler()
        ).done()

  addOptionHandler: ->
    $option = $('.new-option:last')
    $nameInput = $option.find('.option-name')
    $submit = $option.find('a')

    $submit.on 'click', (event) =>
      event.preventDefault()

      Q( $.post $submit.attr('href'),
          poll_id: @el.data('id')
          option:
            name: $nameInput.val()
      )
      .then(
        (html) =>
          $option.remove()
          @options.append(html)
        ,
        (jqXHR, status, errorThrown) =>
          errors = jqXHR.responseJSON.errors
          $('<div>')
            .addClass('notice error')
            .text(errors['name'][0]) # Rails adds error messages as an array.
            .appendTo($option)
          $nameInput.addClass('error')
      ).done()


@PollManager = PollManager
