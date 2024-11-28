class User < ActiveRecord::Base
  # Associations
  has_many :user_servers, dependent: :destroy
  has_many :servers, through: :user_servers
  has_many :achievements, dependent: :destroy

  # Adds methods to set and authenticate against a BCrypt password
  has_secure_password

  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  validate :password_complexity

  # Callbacks
  before_save :downcase_email

  # Instance method to check if a user has unlocked a specific achievement
  def unlocked_achievement?(name)
    achievements.exists?(name: name)
  end

  # Instance method to get all unlocked achievements
  def list_achievements
    achievements.order(unlocked_at: :desc)
  end

  private

  def password_complexity
    return if password.blank?

    regex = /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_])[A-Za-z\d\W_]{1,}\z/
    unless password.match?(regex)
      errors.add :password, "must include at least one lowercase letter, one uppercase letter, one digit, and one special character"
    end
  end

  def downcase_email
    self.email = email.downcase
  end
end
