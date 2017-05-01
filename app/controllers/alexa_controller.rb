class AlexaController < ApplicationController
  skip_before_action :authenticate

  def index
    location = Geocoder.search(params[:zip])
    render text: location.inspect

    #point = RGeo::Geographic.simple_mercator_factory.point @longitude, @latitude

    #@events = Locale.closest()

    #render json: @events.map { |event| { title: event.name, venue: event.venue.name, start_at: event.start_at } }
end