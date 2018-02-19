# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate

  def authenticate
    begin
      token = /(Bearer|JWT) (.+)/.match(request.authorization)

      if token && token[1] == 'JWT'
        decoded_token = JWT.decode token[2], Rails.application.secrets[:secret_key_base], true, algorithm: 'HS256'

        if decoded_token && decoded_token[0]
          @user_id = decoded_token[0]['id']
          @token_id = request.env['token_id'] = decoded_token[0]['jti']

          @token = request.env['decoded_token'] = decoded_token[0]
          request.env['role'] = @token['role']

          return if @user_id
        end
      elsif token && token[1] == 'Bearer'
        @application = Application.find_by(api_key: token[2])

        return if @application
      end

      render status: :unauthorized, json: {}
    rescue => ex
      logger.error ex
      render status: :unauthorized, json: {}
    end
  end

  def kinesis(event, partition, data = {})
    #@kinesis_client ||= Aws::Kinesis::Client.new(region: 'us-west-2', credentials: AWS_CREDENTIALS)

    #@kinesis_client.put_record stream_name: "hotmess-api", data: { environment: Rails.env, event: event, params: data, created_at: DateTime.now.utc }.to_json, partition_key: partition
  end

  def current_user
    puts "UserID => #{@user_id}"
    if @application
      @current_user ||= User.new
    else
      @current_user ||= User.find_by_id(@user_id)
    end
  end

  def current_session
    Session.find_by(token_id: @token_id)
  end

  def admin?
    request.env['role'] == 'admin'
  end
end
