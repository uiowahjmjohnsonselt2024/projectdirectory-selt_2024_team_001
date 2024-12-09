module ApplicationCable
  class Connection < ActionCable::Connection::Base
    # This uniquely identifies a user across all WebSocket connections
    identified_by :current_user

    # Called when the WebSocket connection is established
    def connect
      self.current_user = find_verified_user
      logger.add_tags "ActionCable", "User #{current_user.id}"
    end

    # Called when the WebSocket connection is rejected
    private

    def find_verified_user
      if (user = User.find_by(id: cookies.signed[:user_id]))
        user
      else
        reject_unauthorized_connection
      end
    end
  end
end
