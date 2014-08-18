class User < ActiveRecord::Base
  has_many :votes, dependent: :destroy
  has_many :preferred_options, through: :votes

  validates :email, presence: true
  validates_uniqueness_of :email
  validates :name, presence: true

end
