# Variables
settingsLink = $('.settings')
settings     = $('#settings .dropdown-menu')

# Streams
settingsLink.asEventStream('click')
  .doAction (event) -> 
    $('.tipsy').remove()
    event.preventDefault()
  .onValue -> settings.toggleClass('active')

