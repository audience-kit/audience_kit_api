# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user_id


    def connect
      self.current_user_id = find_user_id
    end

    private
    def find_user_id
      token = /Bearer (.+)/.match(request.authorization)

      if token
        decoded_token = JWT.decode token[1], Rails.application.secrets[:secret_key_base], true, algorithm: 'HS256'

        if decoded_token && decoded_token[0]
          @user_id = decoded_token[0]['id']

          @token = request.env['decoded_token'] = decoded_token[0]
          request.env['role'] = @token['role']

          return if @user_id
        end
      end
    end
  end
end
