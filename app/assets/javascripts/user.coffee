# variables
$form = $('.js-form')

(setupValidation = ->
  form = $('.js-user-form')
  form.validate
    rules:
      "user[email]":
        required: true
        email: true

      "user[password]":
        required: true
        minlength: 6

      "user[password_confirmation]":
        required: true
        equalTo: "#user_password"

    errorPlacement: (error, element) ->
      error.prependTo(element.parents('.js-input:first'))

    unhighlight: (element, errorClass) ->
      $(element.form).find("label[for=\"#{element.id}\"].#{errorClass}").remove()

  form.find('input').jvFloat()
)()

$(document).asEventStream 'blur', '.field_with_errors input'
  .map (event) -> $(event.target)
  .onValue ($input) -> $input.parents('div:first').removeClass('field_with_errors').siblings('.error').remove()

$(document).asEventStream('ajax:success', '.new-user', (event, data, status, xhr) -> data)
  .onValue (html) ->
    Bacon.once $form.addClass('transition')
    .delay 300
    .doAction -> $form.html(html)
    .delay 300
    .onValue ->
      $form.removeClass('transition')
      setupValidation()
      
