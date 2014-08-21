class PollEditor

  constructor: (@el) ->
    @options = $('#options')
    @newOption = $('#add-option')
    @initBindings()
    @initHandlers()

  initBindings: ->
    app.unbind()

    @newOption.on 'click', (event) =>
      event.preventDefault()
      Q( $.get @newOption.attr('href') )
        .then(
          (html) =>
            $('#new-options').append(html)
            @addOptionFormHandler()
        ).done()

    $(document).on 'keydown', (event) =>
      $activeElement = $(document.activeElement)
      # only submit if an input is active
      return $('.option-name:first').focus() unless $activeElement.prop('tagName') == 'INPUT'
      if event.which == 13
        $option = $activeElement.parent('.new-option')
        @saveOption $option, $activeElement, $option.find('a').attr('href')

  initHandlers: ->
    for option in @options.find('.option')
      @addOptionHandler $(option)

  addOption: ($optionForm, html) ->
    $optionForm.remove()
    @options.prepend(html)
    $option = @options.find('.option:last')
    @addOptionHandler($option)

  deleteOption: ($option) ->
    url = "/polls/#{@el.data('id')}/options/#{$option.data('id')}"
    Q( $.ajax
        url: url
        type: 'DELETE'
      )
      .done( -> $option.remove();$('.tipsy').remove() )

  addOptionHandler: ($option) ->
    $option.find('i').on 'click', (event) =>
      @deleteOption($option)

  addOptionFormHandler: ->
    $optionForm = $('.new-option:last')
    $nameInput = $optionForm.find('.option-name')
    $submit = $optionForm.find('a')

    $submit.on 'click', (event) =>
      event.preventDefault()
      @saveOption($optionForm, $nameInput, $submit.attr('href'))

  saveOption: ($optionForm, $nameInput, url) ->
    $optionForm.find('.notice').remove()
    Q( $.post url,
        poll_id: @el.data('id')
        option:
          name: $nameInput.val()
      )
      .then(
        (html) =>
          @addOption($optionForm, html)
        ,
        (jqXHR, status, errorThrown) =>
          @handleError(jqXHR.responseJSON.errors, $nameInput, $optionForm)
      ).done()


  handleError: (errors, $nameInput, $option) ->
    $('<div>')
      .addClass('notice error')
      .text(errors['name'][0]) # Rails adds error messages as an array.
      .appendTo($option)
    $nameInput.addClass('error')


@PollEditor = PollEditor
