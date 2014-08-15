class Poll < ActiveRecord::Base
  has_many :options, dependent: :destroy

  validates :name, presence: true,
                  length: { minimum: 5 }
end
