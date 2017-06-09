class AlexaController < ApplicationController
  before_action :alexa_device

  CLIENT_SECRET = 'Z14rpM0Pqew/t44ysFOSD7XKqSnmCUSrie6Zwlt3NSc='

  def events
    locale = Locale.from_locale_name params[:locale]

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

  def ping

  end

  private
  def alexa_device
    @device = Device.from_identifier request.headers['X-Device-Id'], type: 'alexa'

    @device_user_id = request.headers['X-User-Id']
  end
end