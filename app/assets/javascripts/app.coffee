class App

  constructor: (@el) ->
    @pollId = null
    @auth = new Auth()
    @router = new Router()
    @initBindings()

  initBindings: ->
    @el.on 'auth', =>
      @auth.login()

    @el.on 'header', =>
      @tipsy()

    @el.on 'poll:new', (event, data) =>
      unless $('#poll-form').length > 0 # Called through popstate
        @pollId = null
        @getForm()
      else
        @form = new PollForm($('#poll-form'))
        @auth.updateHeader()
        @router.push { url: '/', action: 'new' }

    @el.on 'poll:edit', (event, data) =>
      @pollId = data.id
      if data.html? # the form was added through an AJAX call
        @el.html(data.html)
        @auth.updateHeader()

      @pollEditor = new PollEditor($('#poll-edit'))
      @router.push { url: "/polls/#{@pollId}/edit", action: 'edit' }

  unbind: ->
    $(document).off 'keydown'

    #
    # @el.on 'poll:show', =>
    #   @unBind()
    #   @tipsy()
    #   Q( $.ajax
    #         url: "/polls/#{@el.find('#poll-container').data('id')}"
    #         dataType: 'json'
    #   )
    #   .then( (json) => @poll = new Poll($('#poll-container'), json)).done()

      # Back to the Start (Razorlight)
        # @pollId = null
        # @auth.updateHeader()

      # @form.unbind() if @form?

      # if state?
      #   switch state.action
      #     when 'new' then @getPollForm()
      #     when 'edit' then @getPollOptions()
      #     else @getPollForm()
      # else
      #   @updateHistory('/')
      #   @getPollForm()
      #   @auth.getHeader()

  tipsy: ->
    $('.tipsy').remove()
    $('i').tipsy gravity: 'n'

  getForm: ->
    Q( $.get '/polls/new' )
    .then(
      (html) =>

        @el.html(html) ).done()

  getPoll: ->
    Q( $.get "/polls/#{@poll.id}" ).then( (html) => @el.html(html)).done()

  getPollOptions: ->
    Q( $.get "/polls/#{@pollEditor.id}/edit" ).then( (html) => @el.html(html)).done()


@App = App
