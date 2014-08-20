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
      Q( $.get '/current_user' )
      .then(
        (html) =>
          $('header').html(html)
          @initBindings()
      ).done()
      $('#main').trigger('login')


    $('.logout').on 'ajax:complete', =>
      @loggedIn = false
      Q( $.get '/current_user' )
      .then(
        (html) =>
          $('header').html(html)
          @initBindings()
      ).done()

      $('#main').trigger('logout')


@Auth = Auth
