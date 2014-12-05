  class Option < ActiveRecord::Base
  belongs_to :poll
  has_many :votes, dependent: :destroy

  validates :name, presence: true

  def as_json(options={})
    { value: votes.count, label: name, id: id }
  end

  def to_s
    "option"
  end

end
