$.extend
  findOrCreate: (selector) ->
    if $(selector).length > 0 then $(selector) else $("<div class='#{selector.replace('.','')}'></div>")
  
  exists: (selector) ->
    if $(selector).length > 0 then true else false

$.fn.extend
  hasParent: (selector) ->
    @.parents(selector).length > 0 

  spinner: ->
    @.html("<div class='spinner'></div>");

  toggleText: (string1, string2) ->
    if @.text().indexOf(string1) > -1
      @.text @.text().replace(string1, string2)
    else
      @.text @.text().replace(string2, string1)

  popup: (text) ->
    $popup = $.findOrCreate('.popup').text(text)
    @.css('position', 'relative').prepend($popup)
  
  selectText: ->
    element = @[0]
    if (document.body.createTextRange)
      range = document.body.createTextRange()
      range.moveToElementText(element)
      range.select()
    else if (window.getSelection)
      selection = window.getSelection()
      range = document.createRange() 
      range.selectNodeContents(element)
      selection.removeAllRanges()
      selection.addRange(range)
   

