flash = $('.flash')

Bacon.once(flash)
  .delay(3000)
  .doAction -> flash.addClass('transition')
  .delay(500)
  .onValue -> flash.remove()
