class UsersController < ApplicationController
  def me
    @user = user
  end

  def location
    @latitude = params[:coordinates][:latitude]
    @longitude = params[:coordinates][:longitude]

    @point = RGeo::Geographic.simple_mercator_factory.point @longitude, @latitude

    user_location = HotMessModels::UserLocation.new user: user, point: @point

    user_location.venue = HotMessModels::Venue.closest @point, within: true
    Rails.logger.info "Location #{@point} registered venue as #{user_location.venue.id}" if user_location.venue

    # Override with becaons if available
    if params[:beacon] and params[:beacon][:major] != 0
      user_location.locale = HotMessModels::Locale.find_by(beacon_major: params[:beacon][:major])

      if params[:beacon][:minor] != 0
        user_location.beacon_minor = params[:beacon][:minor]

        user_location.venue = HotMessModels::Venue.find_by(locale: user_location.locale, beacon_id: user_location.beacon_minor)
      end
    end

    user_location.location = user_location.venue.location if user_location.venue
    user_location.location = HotMessModels::Locale.closest(@point).location unless user_location.locale

    user_location.save
  end

  def picture
    redirect_to "https://facebook.com/#{HotMessModels::User.find(params[:id]).facebook_id}/picture"
  end
end