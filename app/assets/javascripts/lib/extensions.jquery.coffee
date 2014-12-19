$.fn.extend
  findOrCreate: (selector) ->
    if $(selector).length?  then $(selector) else $("<div class='#{selector}'></div>")
