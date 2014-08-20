class Poll < ActiveRecord::Base
  has_many :options, dependent: :destroy
  has_and_belongs_to_many :users
  belongs_to :owner, class_name: 'user', foreign_key: 'owner_id'
  has_many :votes, dependent: :destroy

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
