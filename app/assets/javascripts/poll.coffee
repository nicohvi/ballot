$('.js-poll-form').validate
  rules:
    "poll[name]":
      required: true
      minlength: 5

  errorPlacement: (error, element) ->
    error.prependTo(element.parents('.js-input:first'))

  unhighlight: (element, errorClass) ->
    $(element.form).find("label[for=\"#{element.id}\"].#{errorClass}").remove()


share = $(document).asEventStream('click', '.share-poll')
  .doAction (event) -> event.preventDefault()

share.filter -> $('.popup').length > 0 
  .onValue -> $('.popup').remove()

share.filter -> !$('.popup').length > 0
  .map (event) -> $(event.target).parents('a:first')
  .onValue ($el) -> 
    $el.parents('aside:first').popup($el.data('url'))
    $('.popup').selectText()
