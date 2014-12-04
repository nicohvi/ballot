class Guest
  attr_accessor :token, :has_poll

  def initialize(token)
    @token     = token
    @has_poll  = Poll.exists?(guest_token: token)
    Rails.logger.info "Guest created with token #{@token}"
  end
 
  def name
    'Guest'
  end

  def voted_for?(object)
    object.votes.pluck(:guest_token).include? @token
  end

  def vote(option)
    return false if voted_for?(option)
    poll = option.poll
    remove_old_vote(poll) if voted_for?(poll)
    poll.votes << Vote.new(option: option, user: self)
  end

  private

  def remove_old_vote(poll)
    poll.votes.delete(poll.votes.find_by(guest_token: @token))
  end

end
