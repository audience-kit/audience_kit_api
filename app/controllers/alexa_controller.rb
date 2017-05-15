class AlexaController < ApplicationController
  skip_before_action :authenticate

  before_action :alexa_authenticate

  def events
    location = Geocoder.search(params[:zip]).first

    point = RGeo::Geographic.simple_mercator_factory.point location.longitude, location.latitude

    locale = Locale.closest(point)

    @events = locale.events.take(3)

    render json: { locale: locale.name, events: @events.map { |event| {
        title: event.name,
        venue: event.venue.name,
        start_at: event.start_at,
        timezone_delta: locale.timezone_zulu_delta
    } } }
  end

  def friends

  end

  private
  def alexa_authenticate
    key = /Bearer (.*)/.match(request.authorization)

    return render status: 401 unless key[0] == Rails.application.secrets.alexa_woker_key
  end
end