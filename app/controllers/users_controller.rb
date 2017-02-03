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

    @user.user_locations << UserLocation.new(location: @point)


    @user.save
  end
end