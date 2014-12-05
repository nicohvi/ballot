# variables
options = $('.options')
optionInput = $('#new_option input').val('')

# functions
toggleForm = ($option, name = null) ->
  name ||= $option.find('.name').text()
  $option.find('.name').toggle().text(name)
  $option.find('.edit_option').toggle()

toggleTitle = (name = null) ->
  name = name || $('.form').find('#poll_name').val()
  $('.form').toggle().find('#poll_name').focus()
  $('.poll-title h1').text(name).toggle()

# streams
newOptionStream = $(document).asEventStream 'ajax:success', '#new_option', (event, data, status, xhr) -> data

editOptionStream = $(document).asEventStream 'ajax:success', '.edit_option'
  .map (event) -> $(event.target)

editPollStream = $(document).asEventStream 'ajax:success', '.edit_poll'
  .map (event) -> $(event.target)

deleteOptionStream = $(document).asEventStream 'ajax:success', '.delete-option'
  .map (event) -> $(event.target).parents('.option:first')

$(document).asEventStream 'ajax:error'
  .onValue -> console.log 'something bad happened'

$(document).asEventStream 'click', '.edit-option'
  .onValue (event) -> toggleForm $(event.target).parents('.option:first')

$(document).asEventStream 'click', '.small'
  .onValue (event) -> toggleTitle()

# subscribers
newOptionStream
  .doAction -> optionInput.val ''
  .onValue (html) ->
    options.append html
    options.find('.option:last i').tipsy { gravity: 'n' }
    $('.hidden').removeClass('hidden')

editOptionStream.onValue ($form) -> toggleForm $form.parents('.option:first'), $form.find('#option_name').val()

editPollStream.onValue ($form) -> toggleTitle $form.find('#poll_name').val()

deleteOptionStream.onValue ($option) ->
  $('.tipsy').remove()
  $option.remove()


