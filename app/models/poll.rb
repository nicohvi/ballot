class Poll < ActiveRecord::Base
  has_many :options, dependent: :destroy

  validates :name, presence: true,
                  length: { minimum: 5 }

  def initialize(params={})
    super(params)
    self.slug = SecureRandom.hex(10)
  end

  def to_param
    slug
  end

end
