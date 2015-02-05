class EmailsController < ApplicationController

  def handle
    @email = PostMark::Json.dece(request.body.read)
    logger.log @email.inspect
  end

end
