# frozen_string_literal: true

class TokenController < ApplicationController
  skip_before_action :authenticate

  def create
    # accept token from facebook
    params.require :facebook_token
    params.require :device

    begin
      # Validate and exchange for long token
      extended_token  = Concerns::Facebook.oauth.exchange_access_token params[:facebook_token]

      render status: :unauthorized, json: {} and return unless extended_token

      @graph = Koala::Facebook::API.new extended_token

      # Refresh profile data including email address
      @me = @graph.get_object 'me', fields: %w(email name locale first_name last_name gender)

      raise 'Facebook token invalid' unless @me

      # Create or Update user by application scoped FacebookID
      @user = User.from_facebook_graph @me, extended_token


      @device = Device.from_identifier params['device']['identifier'], type: params['device']['type']

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

      UpdateUserJob.perform_later @user

      kinesis :user_session_create,  @session.user.id, id: @session.id, user_id: @session.user.id
    rescue Koala::Facebook::APIError => ex
      logger.error ex
      #UGLY - gracefully handle some facebook exceptions
      return render template: 'shared/fault', status: 400
    rescue => ex
      logger.error ex
      return render template: 'shared/fault', status: 400
    end
  end

  def device
    @device = Device.find_by(device_type: params[:device_type], vendor_identifier: params[:vendor_identifier])

    @device.notification_token = params[:notification_token]

    @device.save

    render nothing: true
  end
end