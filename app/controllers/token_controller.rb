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
      @me = @graph.get_object 'me'

      # Create or Update user by application scoped FacebookID
      @user = User.from_facebook_graph @me

      @user.facebook_token            = extended_token
      @user.facebook_token_issued_at  = DateTime.now

      @user.save

      @device = Device.from_identifier params['device']['identifier'], type: params['device']['type']

      @session = Session.new device: @device,
                               user: @user,
                          origin_ip: request.remote_ip

      @session.save

      token = @session.to_jwt request

      UpdateUserJob.perform_later @user

      return render json: { token: token }
    rescue => ex
      return render status: 400
    end
  end

  def exchange

  end
end