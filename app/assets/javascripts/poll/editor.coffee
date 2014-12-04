# variables
options = $('.options')
optionInput = $('#new_option input').val('')

# functions
toggleForm = ($option, name = null) ->
  name ||= $option.find('.name').text()
  $option.find('.name').toggle().text(name)
  $option.find('.edit_option').toggle()

# streams
newOptionStream    = $(document).asEventStream 'ajax:success', '#new_option', (event, data, status, xhr) -> data
editOptionStream   = $(document).asEventStream 'ajax:success', '.edit_option'
  .map (event) -> $(event.target)
deleteOptionStream = $(document).asEventStream 'ajax:success', '.delete-option'
  .map (event) -> $(event.target).parents('.option:first')

# subscribers
newOptionStream
  .doAction -> optionInput.val ''
  .onValue (html) ->
    options.append html
    options.find('.option:last i').tipsy { gravity: 'n' }
    $('.hidden').removeClass('hidden')

$(document).asEventStream 'click', '.edit-option'
  .onValue (event) -> toggleForm $(event.target).parents('.option:first')

editOptionStream.onValue ($form) -> toggleForm $form.parents('.option:first'), $form.find('#option_name').val()

deleteOptionStream.onValue ($option) ->
  $('.tipsy').remove()
  $option.remove()

$(document).asEventStream 'ajax:error'
  .onValue -> console.log 'something bad happened'

