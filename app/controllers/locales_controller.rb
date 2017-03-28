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

    kinesis :user_location_update, current_user.id, user_id: current_user.id, longatude: @longitude, latitude: @latitude

    render :show
  end

  def events
    @locale = HotMessModels::Locale.find params[:id]

    @events = @locale.events

    render 'events/index'
  end

  def photo
    @locale = HotMessModels::Locale.find params[:id]
    redirect_to "/photos/#{@locale.location.photo_id}"
  end
end