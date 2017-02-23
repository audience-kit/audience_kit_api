class VenuesController < ApplicationController
  def index
    @venues =  Venue.all

    @venues = @venues.where(locale_id: params[:locale_id], hidden: false) if params[:locale_id]

    if params[:latitude] and params[:longitude]
      point = RGeo::Geographic.simple_mercator_factory.point(params[:longitude], params[:latitude])

      @venues = @venues.select("*, st_distance(location, '#{point.as_text}') as distance").order('distance')
    end
  end

  def show
    @venue = Venue.find params[:id]
  end

  def closest
    @latitude = params.require :latitude
    @longitude = params.require :longitude

    @point = RGeo::Geographic.simple_mercator_factory.point @longitude, @latitude

    @venue = Venue.closest @point

    render :show
  end


  def friends
    @friends = User.first(5)
  end
end