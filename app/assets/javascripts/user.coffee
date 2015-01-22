(setupValidation = -> 
  $('.new_user').validate
    rules:
      "user[email]": 
        required: true
        email: true

      "user[password]":
        required: true
        minlength: 6

      "user[password_confirmation]":
        required: true
        equalTo: "user[password]"

    errorPlacement: (error, element) ->
      error.prependTo(element.parents('.input:first'))
 )()

$(document).asEventStream('ajax:success', '.new_user', (event, data, status, xhr) -> data)
  .onValue (html) -> 
    Bacon.once($('.form').addClass('transition'))
    .delay 300
    .doAction -> $('.form').html(html)
    .delay 300
    .onValue -> 
      $('.form').removeClass('transition')
      setupValidation()
      
