  class Option < ActiveRecord::Base
  belongs_to :poll
  has_many :votes, dependent: :destroy
  has_many :voters, through: :votes, source: :user

  validates :name, presence: true

end
