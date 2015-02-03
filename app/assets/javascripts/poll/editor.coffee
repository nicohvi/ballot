# functions
toggleForm = (option) ->
  option.find('.name').toggle()
  option.find('form').toggle()

setupValidation = (form) ->
  form.validate
    rules:
      "option[name]":
        required: true

    errorPlacement: (error, element) ->
      error.prependTo(element.parents('.js-input:first'))

    unhighlight: (element, errorClass) ->
      $(element.form).find("label[for=\"#{element.id}\"].#{errorClass}").remove()

$(document).asEventStream('click', '.js-edit-option')
.debounceImmediate(500)
.map (event) -> $(event.target).parents('.option:first')
.onValue ($el) -> toggleForm($el)

$(document).asEventStream('ajax:success', '.js-delete-option') 
  .map (event) -> $(event.target).parents('.option:first')
  .onValue ($el) -> 
    $('.tipsy').remove()
    $el.remove()

$(document).asEventStream('ajax:success', '.option .option-form')
  .map (event) ->
    option: $(event.target).parents('.option:first'),
    name:   $(event.target).find('#option_name').val()
  .onValue (hash) -> 
    hash.option.find('.name').text(hash.name)
    toggleForm(hash.option)

$(document).asEventStream('ajax:success', '.new-option', (event, data, status, xhr) -> data)
  .onValue (html) -> 
    $('.new-option').find('#option_name').val('')
    $('.options').append(html)

$(document).asEventStream('click', '.option-form .icon-check')
  .map (event) -> $(event.target).parents('form')
  .onValue ($form) -> $form.submit()

setupValidation $('.new-option')

