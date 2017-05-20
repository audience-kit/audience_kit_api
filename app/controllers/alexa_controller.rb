class AlexaController < ApplicationController
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
end