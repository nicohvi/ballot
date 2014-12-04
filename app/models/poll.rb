class Poll < ActiveRecord::Base
  include Hashable

  # Associations
  has_many :options, dependent: :destroy
  has_and_belongs_to_many :voters, class_name: 'User'
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  has_many :votes, dependent: :destroy
  
  # Validations
  validates :name, presence: true,
                  length: { minimum: 5 }

  def initialize(params={})
    if params[:owner].is_a? Guest
      params[:guest_token] = params.delete(:owner).token
    end
    super
  end

  def as_json(opts={})
    super().merge(options: options.as_json, voted_for: get_vote(opts[:user]))
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
    user.is_a?(Guest) ? votes.find_by(guest_token: user.token).option_id : votes.find_by(user_id: user.id).option_id
  end

  def change!(close)
    self.closed = close
    save if self.changed? # only actually call the database if the object is changed.
  end
  


end
