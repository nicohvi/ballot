class User < ActiveRecord::Base
  has_many :votes, dependent: :destroy
  has_many :created_polls, class_name: 'Poll', foreign_key: 'owner_id'

  has_and_belongs_to_many :polls

  validates :email, presence: true
  validates_uniqueness_of :email
  validates :name, presence: true

  def voted_for?(option)
    votes.include? Vote.find_by_option_id(option.id)
  end

  def vote(option)
    poll = option.poll
    if votes.include? votes.find_by_option_id(option.id)
      poll.errors[:base] << 'You already voted for this option, bruv.'
      return false
    end
    # Has the user already voted in this poll? If so, delete the old vote
    if polls.include? poll
      previous_vote = votes.find_by_poll_id(poll.id)
      votes.delete(previous_vote)
      poll.message = "You changed your vote - way to flip flop."
    # Otherwise, add her as a participant.
    else
      polls << poll
    end
    votes << Vote.new(option: option, poll: poll)
  end

end
