class Poll < ActiveRecord::Base
  has_many :options, dependent: :destroy
  has_and_belongs_to_many :users

  validates :name, presence: true,
                  length: { minimum: 5 }

  def initialize(params={})
    super(params)
    self.slug = SecureRandom.hex(10)
  end

  def to_param
    slug
  end

  def vote(user, option)
    self.users << user
    option.votes << Vote.new(user: user)
  end

end
