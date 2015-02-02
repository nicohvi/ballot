<<<<<<< HEAD
(setupValidation = -> 
  $('.new_user').validate
    rules:
      "user[email]": 
=======
# variables
$form = $('.js-form')

(setupValidation = ->
  $('.new_user').validate
    rules:
      "user[email]":
>>>>>>> 6e45eede0e630979ac71ca474652aaebb8e33efd
        required: true
        email: true

      "user[password]":
        required: true
        minlength: 6

      "user[password_confirmation]":
        required: true
        equalTo: "#user_password"

    errorPlacement: (error, element) ->
      error.prependTo(element.parents('.input:first'))
<<<<<<< HEAD
=======

    unhighlight: (element, errorClass) ->
      $(element.form).find("label[for=\"#{element.id}\"]").removeClass(errorClass)

  $('.new_user input').jvFloat()
>>>>>>> 6e45eede0e630979ac71ca474652aaebb8e33efd
)()

$(document).asEventStream 'blur', '.field_with_errors input'
  .map (event) -> $(event.target)
  .onValue ($input) -> $input.parents('div:first').removeClass('field_with_errors').siblings('.error').remove()

$(document).asEventStream('ajax:success', '.new_user', (event, data, status, xhr) -> data)
<<<<<<< HEAD
  .onValue (html) -> 
    Bacon.once($('.form').addClass('transition'))
    .delay 300
    .doAction -> $('.form').html(html)
    .delay 300
    .onValue -> 
      $('.form').removeClass('transition')
=======
  .onValue (html) ->
    Bacon.once $form.addClass('transition')
    .delay 300
    .doAction -> $form.html(html)
    .delay 300
    .onValue ->
      $form.removeClass('transition')
>>>>>>> 6e45eede0e630979ac71ca474652aaebb8e33efd
      setupValidation()
      
