class AlexaController < ApplicationController
  skip_before_action :authenticate, only: [ :token ]

  CLIENT_SECRET = 'Z14rpM0Pqew/t44ysFOSD7XKqSnmCUSrie6Zwlt3NSc='

  def events
    @device = Device.from_identifier request.headers['X-Device-Id'], type: 'alexa'

    location = Geocoder.search(params[:zip]).first

    point = RGeo::Geographic.simple_mercator_factory.point location.longitude, location.latitude

    locale = Locale.closest(point)

    @events = locale.events.take(3)

    render json: {
        locale: locale.name,
        timezone_delta: locale.timezone_zulu_delta,
        events: @events.map do |event|
          {
            title: event.name,
            venue: event.venue.name,
            start_at: event.start_at
          }
        end
    }
  end

  def friends

  end

  def token
    render status: :unauthorized and return if params[:client_secret] != CLIENT_SECRET

    # accept token from facebook
    params.require :code

    begin
      # Validate and exchange for long token
      token = Concerns::Facebook.oauth.get_access_token params[:code]

      extended_token  = Concerns::Facebook.oauth.exchange_access_token token

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

      render json: { access_token: @token, refresh_token: @token }
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