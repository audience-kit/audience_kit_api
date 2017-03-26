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

    kinesis.put_record :user_location_update, user_location.user.id, user_id: user.id, longatude: @longitude, latitude: @latitude

    render :show
  end

  def photo
    @locale = HotMessModels::Locale.find params[:id]
    redirect_to "/photos/#{@locale.location.photo.id}"
  end
end