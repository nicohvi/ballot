flash = $('.flash')

Bacon.once(flash)
  .delay(3000)
  .onValue -> flash.addClass('transition')
