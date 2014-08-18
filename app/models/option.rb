class Option < ActiveRecord::Base
  belongs_to :poll

  validates :name, presence: true
  
end
