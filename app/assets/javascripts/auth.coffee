class Auth

  constructor: ->
    @url = '/auth/google_oauth2'
    @initBindings()

  initBindings: ->
      $('.login').on 'click', (event) =>
        params = 'location=0,status=0,width=800,height=600'
        googleWindow = window.open(@url, 'googleWindow', params)
        googleWindow.focus()

      $('.share').on 'click', (event) =>
        if $('.share-box').length > 0 then @removeShareBox() else @showShareBox()

  updateHeader: ->
    id = app.pollId
    if id? then url = "/current_user?poll_id=#{id}" else url = "/current_user"
    Q( $.ajax
          url: url
          dataType: 'html'
    )
    .then(
      (html) =>
        $('header').html(html)
        @initBindings()
    )
    .done()

  showShareBox: ->
    $link = $('.share')
    $shareBox = $('<div>').addClass('share-box').appendTo('header')

    $("<input disabled value=#{$link.data('url')} />").appendTo($shareBox)

    left = $link.offset().left - $shareBox.width()/2 + $link.width()/2
    top = $link.offset().top + $link.height() + 20
    $shareBox
      .css { left: "#{left}px",  top: "#{top}px" }
    $shareBox.find('input').select()

  removeShareBox: ->
    $('.share-box').remove()

@Auth = Auth
