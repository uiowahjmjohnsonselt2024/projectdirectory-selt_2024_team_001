# app/channels/application_cable/connection.rb

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      logger.add_tags "ActionCable", current_user.email
    end

    private

    def find_verified_user
      if verified_user_id = cookies.signed[:user_id]
        User.find_by(id: verified_user_id) || reject_unauthorized_connection
      else
        reject_unauthorized_connection
      end
    end
  end
end
