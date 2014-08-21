class Auth

  constructor: ->
    @url = '/auth/google_oauth2'
    @initBindings()

  initBindings: ->
      $('.login').on 'click', (event) =>
        params = 'location=0,status=0,width=800,height=600'
        googleWindow = window.open(@url, 'googleWindow', params)
        googleWindow.focus()

  login: ->
    @updateHeader()

  updateHeader: ->
    id = app.pollId
    if id? then url = "/current_user?poll_id=#{id}" else url = "/current_user"
    Q( $.get url )
    .then(
      (html) =>
        $('header').html(html)
        @initBindings()
    ).done()

@Auth = Auth
