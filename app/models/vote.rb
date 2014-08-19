class Vote < ActiveRecord::Base
  belongs_to :option
  belongs_to :user

  validates_uniqueness_of :user_id, :scope => :option_id

end
