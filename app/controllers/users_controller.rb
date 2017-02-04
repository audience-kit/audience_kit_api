class UsersController < ApplicationController
  def me
    UpdateUserJob.perform_later self.user

    self.user
  end

  def location
    params.require :coordinates

    @latitude = params[:coordinates][:latitude]
    @longitude = params[:coordinates][:longitude]

    @point = RGeo::Geographic.simple_mercator_factory.point @longitude, @latitude

    user_location = UserLocation.new
    user_location.location = @point

    self.user.user_locations << user_location

    self.user.save
  end
end