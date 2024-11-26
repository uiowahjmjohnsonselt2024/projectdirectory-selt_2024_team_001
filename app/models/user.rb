#Model For the user information like email and password using bcypt for passwords.
class User < ActiveRecord::Base
  # Adds methods to set and authenticate against a BCrypt password
  has_and_belongs_to_many :servers
  has_secure_password

  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  validate :password_complexity

  # Callbacks
  before_save :downcase_email

  # Class method for finding and authenticating users
  def self.authenticate(email, password)
    user = find_by(email: email.downcase)
    user&.authenticate(password)
  end

  # Instance method to get full name
  def full_name
    "#{first_name} #{last_name}".strip
  end

  private

  def password_complexity
    return if password.blank?

    regex = /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_])[A-Za-z\d\W_]{1,}\z/
    unless password.match?(regex)
        puts "DEBUG: Password failed complexity check: #{password}"
        errors.add :password, "must include at least one lowercase letter, one uppercase letter, one digit, and one special character"
      end
  end

  def downcase_email
    self.email = email.downcase
  end

end