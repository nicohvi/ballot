require 'postmark'

class EmailsController < ApplicationController
  # No need for CSRF tokens for emails
  skip_before_filter :verify_authenticity_token

  def handle
    @email = PostMark::Json.decode(request.body.read)
    puts "hello heroku: {@email.inspect}"
    render nothing: true, status: 200
  end

end
