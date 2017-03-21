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
    response.headers["Expires"] = 1.day.from_now.httpdate
    @locale = HotMessModels::Locale.find(params[:id])

    if @locale.location&.hero_image
      return send_data @locale.location.hero_image, type: @locale.location.hero_mime
    end

    send_file Rails.root.join "public/homepage_background.jpg"
  end
end