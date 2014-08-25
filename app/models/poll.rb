class Poll < ActiveRecord::Base
  has_many :options, dependent: :destroy
  has_and_belongs_to_many :voters, class_name: 'User'
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  has_many :votes

  validates :name, presence: true,
                  length: { minimum: 5 }

  def initialize(params={})
    super(params)
    self.slug = SecureRandom.hex(10)
  end

  def to_param
    slug
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

end
