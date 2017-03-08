class VenuesController < ApplicationController
  include Concerns::LocationParameters

  skip_before_action :authenticate, only: :photo

  def index
    @venues =  HotMessModels::Venue.all

    @venues = @venues.where(locale_id: params[:locale_id], hidden: false) if params[:locale_id]

    if params[:latitude] and params[:longitude]
      point = RGeo::Geographic.simple_mercator_factory.point(params[:longitude], params[:latitude])

      @venues = @venues.select("*, st_distance(location, '#{point.as_text}') as distance").order('distance')
    end
  end

  def show
    @venue = HotMessModels::Venue.find params[:id]
  end

  def closest
    @venue = HotMessModels::Venue.closest location_param

    render :show
  end

  def now
    @venue = HotMessModels::Venue.closest location_param
    @events = @venue.events

    @friends = @venue.user_locations.recent.map { |ul| ul.user }.select { |u| u != user }.uniq.take(5)


    render :now
  end

  def photo
    @venue = HotMessModels::Venue.find(params[:id])

    if @venue.google_location && @venue.google_location['photos'] && @venue.google_location['photos'].any?
      photo = @venue.google_location['photos'].first

      return redirect_to "https://maps.googleapis.com/maps/api/place/photo?maxheight=1600&maxwidth=1600&key=#{photo['api_key']}&photoreference=#{photo['photo_reference']}"
    end

    redirect_to 'https://hotmess.social/assets/homepage_background-f5ffbb436c2e5c0f7e822a376bb604a5fb66d0acaff989ab330f1246b1ad822c.jpg'
  end
end