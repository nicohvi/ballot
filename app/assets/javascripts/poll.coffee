$('.js-poll-form').validate
  rules:
    "poll[name]":
      required: true
      minlength: 5

  errorPlacement: (error, element) ->
    error.prependTo(element.parents('.js-input:first'))

  unhighlight: (element, errorClass) ->
    $(element.form).find("label[for=\"#{element.id}\"].#{errorClass}").remove()

