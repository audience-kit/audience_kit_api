class ApplicationController < ActionController::API
  before_action :authenticate

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      decoded_token = JWT.decode token, Rails.application.secrets[:secret_key_base], true, algorithm: 'HS256'

      if decoded_token
        @user = User.find(decoded_token[:id])

        return if @user
      end

      render status: :unauthorized
    end
  end
end
