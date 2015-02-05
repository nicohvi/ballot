class EmailsController < ApplicationController

  def handle
    @email = PostMark::Json.dece(request.body.read)
    puts "hello heroku: {@email.inspect}"
  end

end
