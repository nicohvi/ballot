class Auth

  constructor: ->
    @url = '/auth/google_oauth2'
    @initBindings()

  initBindings: ->
    $('.login').on 'click', (event) =>
      params = 'location=0,status=0,width=800,height=600'
      googleWindow = window.open(@url, 'googleWindow', params)
      googleWindow.focus()

    $(window).on 'auth', (event) =>
      Q( $.get '/current_user' ).then( (html) => $('header').html(html)).done()

@Auth = Auth
