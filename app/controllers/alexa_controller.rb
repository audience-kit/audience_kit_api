class AlexaController < ApplicationController
  skip_before_action :authenticate

  def index
    zip = params[:zip] == "99019" ? "98102" : params[:zip]

    location = Geocoder.search(zip).first
    point = RGeo::Geographic.simple_mercator_factory.point location.longitude, location.latitude

    locale = Locale.closest(point)

    @events = locale.events.take(3)

    render json: { locale: locale.name, events: @events.map { |event| { title: event.name, venue: event.venue.name, start_at: event.start_at } } }
  end
end