class UsersController < ApplicationController
  def me
    UpdateUserJob.perform_later @user

    @user
  end

  def location
    params.require :coordinates

    @latitude = params[:coordinates][:latitude]
    @longitude = params[:coordinates][:longitude]

    @point = RGeo::Geographic.spherical_factory.point @longitude, @latitude

    user_location = UserLocation.new
    user_location.location = @point

    @user.user_locations << user_location

    @user.save
  end
end