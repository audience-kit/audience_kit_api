# frozen_string_literal: true

class VenuesController < ApplicationController
  include Concerns::LocationParameters
  include Concerns::PageController

  skip_before_action :authenticate, only: %i[photo picture cover]

  def index
    @venues = Venue.joins(:location).includes(:page)

    if params[:locale_id]
      @venues = @venues.where(locale_id: params[:locale_id], hidden: false)
      @envelope = RGeo::GeoJSON.encode Locale.find(params[:locale_id]).envelope
    end

    if params[:latitude] and params[:longitude]
      point = RGeo::Geographic.simple_mercator_factory.point(params[:longitude], params[:latitude])

      @venues = @venues.select("venues.*, st_distance(locations.point, '#{point.as_text}') as distance").order('distance')
    end
  end

  def show
    @venue = Venue.includes(:page).find(params[:id])

    @is_liked = UserLike.find_by(user: current_user, page: @venue.page) ? true : false

    kinesis :venue_view, @venue.id, id: @venue.id, user_id: current_user.id, is_liked: @is_liked
  end

  def now
    @locale = Locale.closest location_param
    @venue = Venue.closest location_param, within: true

    if @venue
      @title = @venue.display_name
      @events = @venue.events
      @is_liked = UserLike.find_by(user: current_user, page: @venue.page) ? true : false
      @image_url = @venue.location.photo&.cdn_url

      @friends = @venue.user_locations.includes(session: :user).recent.order(created_at: :desc).map { |ul| ul.session.user }.select { |u| u != user }.uniq.take(15)
      @events = @venue.events
    else
      @title = "Happening Now in #{@locale.name}"
      @image_url = url_for(@locale.location&.photo)

      @image_url = @locale.location&.photo.cdn_url

      # TODO: Users who have issued recent pings
      @friends = []
      @events = @locale.events.take(5)
      @venues = @locale.venues.joins(:location).where('venues.hidden IS FALSE').select("venues.*, st_distance(locations.point, '#{@point.as_text}') as distance").order('distance').take(5)
    end

    kinesis :user_location_update, current_user.id, user_id: current_user.id, longatude: @longitude, latitude: @latitude, venue_id: @venue&.id

    venue_section = LayoutSection.new 'Venues'
    venue_section.items = (@venues || []).map(&:to_layout)

    events_section = LayoutSection.new 'Events'
    events_section.items = @events.map { |event| event.to_layout(true) }

    @sections = [ venue_section, events_section ]

    render :now
  end

  def photo
    @venue = Venue.find(params[:id])

    if @venue.location.photo_id
      return redirect_to "/photos/#{@venue.location.photo_id}"
    end

    send_file Rails.root.join "public/homepage_background.jpg"
  end

  def picture
    page_image(Venue.find(params[:id]).page)
  end

  def cover
    page_image(Venue.find(params[:id]).page, :cover)
  end

  def events
    @venue = Venue.find(params[:id])

    @events = @venue.events.includes(event_people: { person: :page })

    render 'events'
  end
end
