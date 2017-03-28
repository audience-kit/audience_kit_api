class ApplicationController < ActionController::API
  before_action :authenticate

  def authenticate
    begin
      token = /Bearer (.+)/.match(request.authorization)

      if token
        decoded_token = JWT.decode token[1], Rails.application.secrets[:secret_key_base], true, algorithm: 'HS256'

        if decoded_token && decoded_token[0]
          @user_id = decoded_token[0]['id']

          @token = request.env['decoded_token'] = decoded_token[0]
          request.env['role'] = @token['role']
          request.env['token_id'] = @token['token_id']

          return if @user_id
        end
      end

      render status: :unauthorized, json: {}
    rescue => ex
      logger.error ex
      render status: :unauthorized, json: {}
    end
  end

  def kinesis(event, partition, data = {})
    @kinesis_client ||= Aws::Kinesis::Client.new(region: 'us-west-2', credentials: AWS_CREDENTIALS)

    @kinesis_client.put_record stream_name: "#{Rails.env}-hotmess-api", data: { event: event, params: data, created_at: DateTime.now.utc }.to_json, partition_key: partition
  end

  def current_user
    puts "UserID => #{@user_id}"
    @current_user ||= HotMessModels::User.find_by_id(@user_id)
  end

  def admin?
    request.env['role'] == 'admin'
  end
end
