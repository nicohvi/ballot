# class Router
#
#   constructor: ->
#     @history = []
#     @initBindings()
#
#   push: (entry) ->
#     @history.push entry
#     window.history.pushState { action: entry.action, url: entry.url }, null, entry.url
#
#   initBindings: ->
#
#     $(window).on 'popstate', (event) =>
#       state = event.originalEvent.state
#       if state && state.action?
#         switch state.action
#           when 'new' then $('#main').trigger('poll:new')
#           else
#
# @Router = Router
