class LocalesController < ApplicationController

  def index
    Locale.all
  end

  def show
    Locale.find params[:id]
  end

  def closest
    @latitude = params.require :latitude
    @longitude = params.require :longitude

    @point = RGeo::Geographic.spherical_factory.point @longitude, @latitude

    @locale = Locale.closest @point

    render :show
  end
end