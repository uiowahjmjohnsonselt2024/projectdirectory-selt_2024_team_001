class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  # Associations
  has_many :user_servers, dependent: :destroy
  has_many :servers, through: :user_servers
  has_many :achievements, dependent: :destroy
  has_many :grid_tile_users
  has_many :grid_tiles, through: :grid_tile_users

  # Adds methods to set and authenticate against a BCrypt password
  has_secure_password

  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  validate :password_complexity
  validates :gold, numericality: { greater_than_or_equal_to: 0 }

  # Callbacks
  before_save :downcase_email
  after_initialize :set_default_settings, if: :new_record?
  after_initialize :set_default_gold

  # Settings Defaults
  DEFAULT_SETTINGS = {
    light_mode: false,
    notifications: true,
    sound_volume: 50,
    graphics_quality: "high",
    language: "en",
    background_color: "black" # Default to dark mode
  }.freeze

  # Serialize settings for compatibility with the database
  serialize :settings, JSON

  # Methods for User Settings

  # Initialize default settings for new users
  def set_default_settings
    self.settings ||= DEFAULT_SETTINGS
  end

  # Save settings changes
  def save_settings(new_settings)
    self.settings = settings.merge(new_settings)
    save
  end

  # Reset settings to default values
  def reset_settings
    self.settings = DEFAULT_SETTINGS
    save
  end

  # Get a specific setting or the entire settings hash
  def get_setting(key = nil)
    settings ||= DEFAULT_SETTINGS # Fallback to defaults if settings is nil
    key ? settings[key.to_s] : settings
  end

  # Methods for background color
  def background_color
    settings['background_color']
  end

  def background_color=(color)
    settings['background_color'] = color
    save
  end

  # Instance method to check if a user has unlocked a specific achievement
  def unlocked_achievement?(name)
    achievements.exists?(name: name)
  end

  # Instance method to get all unlocked achievements
  def list_achievements
    achievements.order(unlocked_at: :desc)
  end

  # Class method for finding and authenticating users
  def self.authenticate(email, password)
    user = find_by(email: email.downcase)
    user&.authenticate(password)
  end

  # Gold management methods
  def set_default_gold
    self.gold ||= 1000
  end

  def adjust_gold(amount)
    self.gold += amount
    save
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
