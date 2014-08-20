class Auth

  constructor: ->
    @url = '/auth/google_oauth2'
    @initBindings()
    @loggedIn = false

  initBindings: ->
    $(window).off 'auth'

    $('.login').on 'click', (event) =>
      params = 'location=0,status=0,width=800,height=600'
      googleWindow = window.open(@url, 'googleWindow', params)
      googleWindow.focus()

    $(window).on 'auth', =>
      @loggedIn = true
      if app.poll? then @getHeader(app.poll.id) else @getHeader()
      $('#main').trigger('login')

    $('.logout').on 'ajax:complete', =>
      @loggedIn = false
      @getHeader()

      $('#main').trigger('logout')

  getHeader: (id=null) ->
    if id? then url = "/current_user?poll_id=#{id}" else url = "/current_user"
    Q( $.get url )
    .then(
      (html) =>
        $('header').html(html)
        @initBindings()
    ).done()



@Auth = Auth
