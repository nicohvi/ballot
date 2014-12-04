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
  
  def close!
    self.closed = true unless closed
    # only actually call the database if the object is changed.
    save if self.changed?
  end

  def open!
    self.closed = false if closed
    # only actually call the database if the object is changed.
    save if self.changed?
  end

  def closed?
    self.closed
  end

  def message
    @message
  end

  def message=(message)
    @message = message
  end

  def owned_by?(user)
    user.is_a?(Guest) ? guest_token == user.token : owner == user 
  end

end
