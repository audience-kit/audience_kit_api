class ApplicationController < ActionController::API
  before_action :authenticate

  def authenticate
    token = /Bearer (.+)/.match(request.authorization)

    if token
      decoded_token = JWT.decode token[1], Rails.application.secrets[:secret_key_base], true, algorithm: 'HS256'

      if decoded_token && decoded_token[0]
        logger.info decoded_token
        @user = User.find_by_id(decoded_token[0]['id'])

        return if @user
      end
    end

    render status: :unauthorized, json: {}
  end
end
