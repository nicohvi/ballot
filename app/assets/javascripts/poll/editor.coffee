optionToggle = (child, newName = null) ->
  $option = child.parents('.option:first')
  $option.find('.name').text(newName) if newName
  $option.find('.name').toggle()
  $option.find('.edit_option').toggle()

$(document).on 'ajax:success', '#new_option', (event, data, status, xhr) ->
  $('#options').append(data)
  $('#options .option:last i').tipsy { gravity: 'n' }
  $('#new_option input').val('')

$(document).on 'ajax:before', '.delete-option', (event) ->
  $('.tipsy').remove()

$(document).on 'ajax:success', '.delete-option', (event, data, status, xhr) ->
  $(@).parents('.option:first').remove()

$(document).on 'click', '.edit-option', (event) ->
  optionToggle $(@)
  $(@).siblings('form').find('input[type="text"]').focus()

$(document).on 'ajax:success', '.edit_option', (event, data, status, xhr) ->
  optionToggle $(@), $(@).find('input[type="text"]').val()



