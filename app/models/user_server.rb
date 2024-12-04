class UserServer < ApplicationRecord
  belongs_to :user
  belongs_to :server

  # Validation to ensure unique association
  validates :user_id, uniqueness: { scope: :server_id, message: "User is already registered to this server" }
end
