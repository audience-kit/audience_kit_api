class LocalesController < ApplicationController
  skip_before_action :authenticate, only: [ :photo ]

  include Concerns::LocationParameters

  def index
    @locales = HotMessModels::Locale.all
  end

  def show
    @locale = HotMessModels::Locale.find params[:id]
  end

  def closest
    @locale = HotMessModels::Locale.closest location_param

    render :show
  end

  def photo
    @locale = HotMessModels::Locale.find params[:id]
    redirect_to "/photos/#{@locale.location.photo.id}"
  end
end