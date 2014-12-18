  class Option < ActiveRecord::Base
  belongs_to :poll
  has_many :votes, dependent: :delete_all

  validates :name, presence: true
  
  # Scopes
  default_scope { order(:id) }

  # Overrides
  def as_json(options={})
    { value: votes.count, label: name, id: id }
  end

  def to_s
    "option"
  end

end
