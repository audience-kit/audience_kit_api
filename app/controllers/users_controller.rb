class UsersController < ApplicationController
  def me
    @user = user
  end

  def location
    @latitude = params[:coordinates][:latitude]
    @longitude = params[:coordinates][:longitude]

    @point = RGeo::Geographic.simple_mercator_factory.point @longitude, @latitude

    user_location = UserLocation.new
    user_location.location = @point

    user_location.venue = Venue.closest @point

    # Override with becaons if available
    if params[:beacon] and params[:beacon][:major] != 0
      user_location.locale = Locale.find_by(beacon_major: params[:beacon][:major])

      if params[:beacon][:minor] != 0
        user_location.beacon_minor = params[:beacon][:minor]

        user_location.venue = Venue.find_by(locale: user_location.locale, beacon_id: user_location.beacon_minor)
      end
    end

    user.user_locations << user_location

    user.save
  end

  def picture
    redirect_to "https://facebook.com/#{User.find(params[:id]).facebook_id}/picture"
  end
end