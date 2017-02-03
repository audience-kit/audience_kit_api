class UsersController < ApplicationController
  def me
    # TODO: This exposes things not meant for the user to ever see
    UpdateUserJob.perform_later @user

    render json: @user
  end

  def location
    params.require :coordinates

    @latitude = params[:coordinates][:latitude]
    @longitude = params[:coordinates][:longitude]

    @point = RGeo::Geographic.spherical_factory.point @longitude, @latitude

    @user.locations << UserLocation.new(location: @point)


    @user.save
  end
end