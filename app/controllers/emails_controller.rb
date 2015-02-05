class EmailsController < ApplicationController
  # No need for CSRF tokens for emails
  skip_before_filter :verify_authenticity_token

  def handle
    @email = PostMark::Json.dece(request.body.read)
    puts "hello heroku: {@email.inspect}"
  end

end
