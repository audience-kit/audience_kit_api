class TokenController < ApplicationController
  skip_before_action :authenticate

  def create
    # accept token from facebook
    params.require :facebook_token
    params.require :device

    # Validate and exchange for long token
    app_id          = Rails.application.secrets[:facebook_app_id]
    app_secret      = Rails.application.secrets[:facebook_secret]
    oauth_handler   = Koala::Facebook::OAuth.new app_id, app_secret
    extended_token  = oauth_handler.exchange_access_token params[:facebook_token]

    render status: :unauthorized and return unless extended_token

    @graph = Koala::Facebook::API.new extended_token

    # Refresh profile data including email address
    @me = @graph.get_object 'me'

    # Create or Update user by application scoped FacebookID
    @user = User.find_or_initialize_by facebook_id: @me['id'].to_i

    @user.name                      = @me['name']
    @user.email_address             = @me['email_address']
    @user.facebook_token            = extended_token
    @user.facebook_token_issued_at  = DateTime.now

    @user.save

    @device = Device.find_or_create_by vendor_identifier: params['device']['identifier'], device_type: params['device']['type']
    @device.save

    @session = Session.new device: @device, user: @user, session_token: SecureRandom.base64, token_id: SecureRandom.uuid
    @session.save

    # produce new JWT token
    payload = {
        id: @user.id,
        fb_id: @me['id'].to_i,
        iat: DateTime.now.to_time.to_i,
        nbf: (DateTime.now - 5.minutes).to_time.to_i,
        # exp: for now calculate exp and return not-authorized if refresh required (exp should never be respected but is a hint)
        iss: request.host_with_port,
        aud: request.host_with_port,
        jti: @session.token_id
    }

    token = JWT.encode payload, Rails.application.secrets[:secret_key_base], 'HS256'

    logger.info "Token: #{token}"

    render json: { token: token }
  end
end