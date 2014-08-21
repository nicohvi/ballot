class User

  constructor: ->
    @initBindings()

  initBindings: ->
    $('.delete-poll').on 'ajax:complete', (xhr, status) ->
      $(@).parents('.poll:first').remove()
      $('.tipsy').remove()

@User = User
