class Poll < ActiveRecord::Base
  include Hashable

  # Associations
  has_many :options, dependent: :delete_all
  has_many :voters, class_name: 'User', through: :votes
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  has_many :votes, dependent: :delete_all
  
  # Validations
  validates :name, presence: true,
                  length: { minimum: 5 }
  
  # Scopes
  def self.random
    if (c = count) != 0
      offset(rand(c)).first 
    end
  end 

  def initialize(params={})
    if params[:owner].is_a? Guest
      params[:guest_token] = params.delete(:owner).token
    end
    super
  end

  def as_json(opts={})
    opts.empty? ? super : super().merge(options: options.as_json, voted_for: get_vote(opts[:user]))
  end

  def to_s
    "poll"
  end

  def close!
    change!(true)
  end

  def open!
    change!(false)
  end

  def owned_by?(user)
    user.is_a?(Guest) ? guest_token == user.token : owner == user 
  end

  private

  def get_vote(user)
    vote = user.is_a?(Guest) ? votes.find_by(guest_token: user.token) : votes.find_by(user_id: user.id)
    vote.nil? ? nil : vote.option_id
  end

  def change!(close)
    self.closed = close
    save if self.changed? # only actually call the database if the object is changed.
  end

end
