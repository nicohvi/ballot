class User < ActiveRecord::Base
  # Associations
  has_many :votes, dependent: :delete_all
  has_many :created_polls, class_name: 'Poll', foreign_key: 'owner_id', dependent: :delete_all
  has_many :polls, through: :votes

  # Custom methods
  has_secure_password

  # Validations
  validates :email, presence: true, uniqueness: { link: Rails.application.routes.url_helpers.new_password_reset_path }
  validates :password, presence: true, length: { minimum: 6 }, if: :password_digest_changed?
  
  def voted_for?(object)
    attribute = "#{object.to_s}_id".to_sym
    votes.pluck(attribute).include? object.id
  end

  def vote(option)
    return false if voted_for?(option) || option.poll.closed
    remove_old_vote(option.poll) if voted_for?(option.poll)
    votes << Vote.new(option: option, poll: option.poll)
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  private

  def remove_old_vote(poll)
    votes.find_by(poll_id: poll.id).delete
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

end
