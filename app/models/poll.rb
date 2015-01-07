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
  validates :guest_token, uniqueness: { link: Rails.application.routes.url_helpers.login_path('google_oauth2'), allow_blank: true }
  
  def initialize(params={})
    if params[:owner].is_a? Guest
      params[:guest_token] = params.delete(:owner).token
    end
    super
  end

  def as_json(opts={})
    user = opts[:user] 
    json = super().merge(options: options.as_json, slug: to_param)
    user ? json.merge(vote: voted_for?(user)) : json
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

  def voted_for?(user)
    options.where(id: get_vote(user)).pluck(:name).first
  end

  private

  def get_vote(user)
    identifier = user.is_a?(Guest) ? 'guest_token' : 'user_id'
    votes.where(identifier.to_sym => user.id).pluck(:option_id).first
  end

  def change!(close)
    self.closed = close
    save if self.changed? # only actually call the database if the object is changed.
  end

end
