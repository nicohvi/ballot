flash = $('.flash')

flash.css('height', flash.outerHeight());

Bacon.once(flash)
  .delay(1000)
  .doAction -> flash.addClass('disappear')
  .delay(10000)
  .onValue -> flash.remove()

