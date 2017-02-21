class ApplicationController < ActionController::API
  before_action :authenticate

  def authenticate
    token = /Bearer (.+)/.match(request.authorization)

    if token
      decoded_token = JWT.decode token[1], Rails.application.secrets[:secret_key_base], true, algorithm: 'HS256'

      if decoded_token && decoded_token[0]
        @user_id = decoded_token[0]['id']

        request.env['decoded_token'] = decoded_token[0]

        return if @user_id
      end
    end

    render status: :unauthorized, json: {}
  end

  def user
    @user ||= User.find_by_id(@user_id)
  end
end
