# Variables
settingsLink = $('.settings')
settings     = $('#settings .dropdown-menu')

# Streams
$(document).asEventStream('click')
  .filter (event) ->
    settings.hasClass('active') || $(event.target).hasClass('settings')
  .filter (event) -> !$(event.target).parents('.dropdown-menu').length > 0
  .doAction (event) ->
    $('.tipsy').remove()
    event.preventDefault()
  .onValue -> settings.toggleClass('active')

