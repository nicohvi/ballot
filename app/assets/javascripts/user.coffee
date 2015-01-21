$(document).asEventStream('ajax:success', '.new_user', (event, data, status, xhr) -> data)
  .onValue (html) -> 
    Bacon.once($('.new_user').addClass('transition'))
    .delay 300
    .doAction -> $('.new_user').html(html)
    .delay 300
    .onValue -> 
      $('.new_user').removeClass('transition')
