# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :authenticate, only: [:picture]

  def me
    @user = current_user
  end

  def coordinates
    @latitude = params[:coordinates][:latitude]
    @longitude = params[:coordinates][:longitude]

    @point = RGeo::Geographic.simple_mercator_factory.point @longitude, @latitude

    session = Session.find_by(token_id: request.env['token_id'])
    user_location = UserLocation.new session: session, point: @point

    user_location.venue = Venue.closest @point, within: true
    Rails.logger.info "Location #{@point} registered venue as #{user_location.venue.id}" if user_location.venue

    # Override with beacons if available
    if params[:beacon] && params[:beacon][:major] != 0
      user_location.locale = Locale.find_by(beacon_major: params[:beacon][:major])

      if params[:beacon][:minor] != 0
        user_location.beacon_minor = params[:beacon][:minor]

        user_location.venue = Venue.find_by(locale: user_location.locale, beacon_id: user_location.beacon_minor)
      end
    end

    user_location.location = user_location.venue.location if user_location.venue
    user_location.location = Locale.closest(@point).location unless user_location.location

    user_location.save

    kinesis :user_location_update, current_user.id, user_id: current_user.id, id: user_location.id, longatude: @longitude, latitude: @latitude
  end

  def picture
    @user = User.find(params[:id])
    redirect_to url_for(@user.photo)
  end
end