class Poll < ActiveRecord::Base
  has_many :options, dependent: :destroy
  has_and_belongs_to_many :voters, class_name: 'User'
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'

  validates :name, presence: true,
                  length: { minimum: 5 }

  def initialize(params={})
    super(params)
    self.slug = SecureRandom.hex(10)
  end

  def to_param
    slug
  end

  def message
    @message
  end

  def message=(message)
    @message = message
  end

end
