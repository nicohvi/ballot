$.extend
  findOrCreate: (selector) ->
    if $(selector).length?  then $(selector) else $("<div class='#{selector}'></div>")

$.fn.extend
  hasParent: (selector) ->
    @.parents(selector).length > 0 
