class Player < ApplicationRecord
  belongs_to :server
  belongs_to :user

  validates :user_id, uniqueness: { scope: :server_id, message: "can only have one player per server" }
end
