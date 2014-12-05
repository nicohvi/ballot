class User < ActiveRecord::Base
  has_many :votes, dependent: :delete_all
  has_many :created_polls, class_name: 'Poll', foreign_key: 'owner_id', dependent: :delete_all
  has_many :polls, through: :votes  

  validates :email, presence: true
  validates_uniqueness_of :email
  validates :name, presence: true
  
  def voted_for?(option)
    votes.find_by_option_id(option.id)
  end

  def vote(option)
    poll = option.poll
    if votes.include? votes.find_by_option_id(option.id)
      poll.errors[:base] << 'You already voted for this option, bruv.'
      return false
    end
    # Has the user already voted in this poll? If so, delete the old vote
    if polls.include? poll
      byebug
      previous_vote = votes.find_by_poll_id(poll.id)
      votes.delete(previous_vote)
    # Otherwise, add her as a participant.
    else
      polls << poll
    end
    votes << Vote.new(option: option, poll: poll)
  end

end
