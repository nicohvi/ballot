class User < ActiveRecord::Base
  has_many :votes, dependent: :destroy
  has_many :preferred_options, through: :votes, source: :option
  has_and_belongs_to_many :polls

  validates :email, presence: true
  validates_uniqueness_of :email
  validates :name, presence: true

  def voted_for?(option)
    preferred_options.include?(option)
  end

end
