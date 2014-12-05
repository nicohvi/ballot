class Vote < ActiveRecord::Base
  belongs_to :option
  belongs_to :user
  belongs_to :poll
  
  validates_uniqueness_of :user_id, scope: :option_id, allow_blank: true
  validates_uniqueness_of :user_id, scope: :poll_id, allow_blank: true
  
  def initialize(params={})
    if params[:user].is_a? Guest
      params[:guest_token] = params.delete(:user).token
    end
    super
  end

end
