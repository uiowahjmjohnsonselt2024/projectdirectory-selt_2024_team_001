class Achievement < ApplicationRecord
  belongs_to :user

  # Validation to ensure achievements have a name and are unique per user
  validates :name, presence: true, uniqueness: { scope: :user_id }

  def self.unlock_for_user(user, name, description = nil)
    user.achievements.find_or_create_by!(name: name) do |achievement|
      achievement.description = description
      achievement.unlocked_at = Time.current
    end
  end

end
