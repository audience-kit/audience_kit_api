class TokenController < ApplicationController
  skip_before_action :validate_authentication

  def create
    # accept token from facebook
    params.require(:facebook_token)

    # validate / exchange for long token
    oauth_handler = Koala::Facebook::OAuth.new Rails.application.secrets[:facebook_app_id], Rails.application.secrets[:facebook_secret]
    extended_token = oauth_handler.exchange_access_token params[:facebook_token]

    @graph = Koala::Facebook::API.new extended_token

    # refresh profile data
    @me = @graph.get_object 'me'

    logger.info "Facebook /me => #{@me}"

    # create or update user
    @user = User.find_or_initialize_by facebook_id: @me['id'].to_i

    @user.facebook_token = extended_token
    @user.name = @me['name']
    @user.facebook_profile_url = @me['link']

    # create or update session

    #store
    @user.save

    # produce new JWT token
    payload = {
        id: @user.id,
        fb_id: @me['id'].to_i,
        iat: DateTime.now.to_time.to_i,
        nbf: (DateTime.now - 5.minutes).to_time.to_i,
        # exp: for now calculate exp and return not-authorized if refresh required (exp should never be respected but is a hint)
        iss: request.host_with_port,
        aud: request.host_with_port,
        jti: SecureRandom.base64
    }

    token = JWT.encode payload, Rails.application.secrets[:secret_key_base], 'HS256'

    logger.info "Token: #{token}"

    render json: { token: token }
  end
end