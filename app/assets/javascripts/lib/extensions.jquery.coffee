$.extend
  findOrCreate: (selector) ->
    if $(selector).length?  then $(selector) else $("<div class='#{selector}'></div>")
  
  exists: (selector) ->
    if $(selector).length > 0 then true else false

$.fn.extend
  hasParent: (selector) ->
    @.parents(selector).length > 0 

  spinner: ->
    @.html("<div class='spinner'></div>");
