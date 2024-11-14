#Model For the user information like email and password using bcypt for passwords.
class User < ActiveRecord::Base
  # Adds methods to set and authenticate against a BCrypt password
  #has_secure_password

  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  validate :password_complexity

  # Callbacks
  before_save :downcase_email

  # Enum for roles (optional)
  enum role: { member: 0, admin: 1 }
  after_initialize :set_default_role, if: :new_record?

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
    return if password.blank? || password =~ /(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[\W])/

    errors.add :password, "must include at least one lowercase letter, one uppercase letter, one digit, and one special character"
  end

  def downcase_email
    self.email = email.downcase
  end

  def set_default_role
    self.role ||= :member
  end
end