$(document).on 'ajax:before', '#add-option', (event) ->
  if $('.new_option').length > 0
    $('#option_name').focus()
    false

$(document).on 'ajax:success', '#add-option', (event, data, status, xhr) ->
  $('#edit-poll').append(data)
  $('#option_name').focus()

$(document).on 'ajax:success', '#new_option', (event, data, status, xhr) ->
  $('#options').append(data)
  $('#options i:last').tipsy { gravity: 'n' }
  $('#option_name').val('')

$(document).on 'ajax:before', '.delete-option', (event) ->
  $('.tipsy').remove()

$(document).on 'ajax:success', '.delete-option', (event, data, status, xhr) ->
  $(@).parents('.option:first').remove()
