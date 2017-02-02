class VenuesController < ApplicationController
  def index
    @venues =  Venue.all

    @venues = @venues.where(locale_id: params[:locale_id]) if params[:locale_id]

    if params[:latitude] and params[:longitude]
      point = RGeo::Geographic.spherical_factory.point(params[:longitude], params[:latitude])

      @venues = @venues.order("st_distance(location, '#{point.as_text}')")
    end
  end

  def show
    @venue = Venue.find params[:id]
  end
end