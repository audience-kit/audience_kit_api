class TokenController < ApplicationController
  skip_before_action :authenticate

  def create
    # accept token from facebook
    params.require :facebook_token
    params.require :device

    begin
      # Validate and exchange for long token
      extended_token  = HotMessModels::Concerns::Facebook.oauth.exchange_access_token params[:facebook_token]

      render status: :unauthorized, json: {} and return unless extended_token

      @graph = Koala::Facebook::API.new extended_token

      # Refresh profile data including email address
      @me = @graph.get_object 'me'

      raise 'Facebook token invalid' unless @me

      # Create or Update user by application scoped FacebookID
      @user = HotMessModels::User.from_facebook_graph @me, extended_token


      @device = HotMessModels::Device.from_identifier params['device']['identifier'], type: params['device']['type']

      @device.model ||= params['device']['model']
      @device.save
      logger.error "Hell Frozen Over #{@device.model} -> #{params['device']['model']}" if @device.model != params['device']['model']

      @session = @device.sessions.build device: @device,
                                          user: @user,
                                     origin_ip: request.remote_ip,
                                       version: params['device']['version'],
                                         build: params['device']['build']

      @session.save

      @token = @session.to_jwt(request).to_s

      kinesis = Aws::Kinesis::Client.new(
          region: 'us-west-2',
          credentials: Aws::Credentials.new(Rails.application.secrets[:aws_key_id], Rails.application.secrets[:aws_secret])
      )

      stream_name = "#{Rails.env}-hotmess-api"
      result = kinesis.put_record stream_name: stream_name, data: { type: :user_session_create, id: @session.id, partition_key: @session.user.id }
      puts "Kinesis user_session_create result => #{result}"

    rescue Koala::Facebook::APIError => ex
      logger.error ex
      #UGLY - gracefully handle some facebook exceptions
      return render template: 'shared/fault', status: 400
    rescue => ex
      logger.error ex
      return render template: 'shared/fault', status: 400
    end
  end
end