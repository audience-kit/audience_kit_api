class VenuesController < ApplicationController
  include Concerns::LocationParameters
  include Concerns::PageController

  skip_before_action :authenticate, only: :photo

  def index
    @venues =  HotMessModels::Venue.joins(:location).includes(venue_pages: :page)

    if params[:locale_id]
      @venues = @venues.where(locale_id: params[:locale_id], hidden: false)
      @envelope = RGeo::GeoJSON.encode HotMessModels::Locale.find(params[:locale_id]).envelope
    end

    if params[:latitude] and params[:longitude]
      point = RGeo::Geographic.simple_mercator_factory.point(params[:longitude], params[:latitude])

      @venues = @venues.select("venues.*, st_distance(locations.location, '#{point.as_text}') as distance").order('distance')
    end
  end

  def show
    @venue = HotMessModels::Venue.includes(venue_pages: :page).find(params[:id])
  end

  def closest
    @venue = HotMessModels::Venue.closest location_param

    render :show
  end

  def now
    @locale = HotMessModels::Locale.closest location_param
    @venue = HotMessModels::Venue.closest location_param, within: true

    if @venue
      @title = @venue.display_name
      @events = @venue.events
      @image_url = "#{url_for(@venue)}/photo"

      @friends = @venue.user_locations.recent.map { |ul| ul.user }.select { |u| u != user }.uniq.take(5)
    else
      @title = "Happening Now in #{@locale.name}"
      @image_url = 'https://hotmess.social/assets/homepage_background-f5ffbb436c2e5c0f7e822a376bb604a5fb66d0acaff989ab330f1246b1ad822c.jpg'

      if  @locale &&
          @locale.location &&
          @locale.location.photos &&
          @locale.location.photos.any?

        photo = @locale.location.photos.first
        @image_url = "https://maps.googleapis.com/maps/api/place/photo?maxheight=1600&maxwidth=1600&key=#{photo['api_key']}&photoreference=#{photo['photo_reference']}"
      end

      @events = @locale.events.take(5)
      @venues = @locale.venues.joins(:location).select("venues.*, st_distance(locations.location, '#{@point.as_text}') as distance").order('distance').take(5)
    end

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

  def picture
    page_image(HotMessModels::Venue.find(params[:id]).page)
  end

  def cover
    page_image(HotMessModels::Venue.find(params[:id]).page, :cover)
  end
end