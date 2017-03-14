class LocalesController < ApplicationController
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
    @locale = HotMessModels::Locale.find(params[:id])

    if @locale.google_location && @locale.google_location['photos'] && @venue.google_location['photos'].any?
      photo = @locale.google_location['photos'].first

      return redirect_to "https://maps.googleapis.com/maps/api/place/photo?maxheight=1600&maxwidth=1600&key=#{photo['api_key']}&photoreference=#{photo['photo_reference']}"
    end

    redirect_to 'https://hotmess.social/assets/homepage_background-f5ffbb436c2e5c0f7e822a376bb604a5fb66d0acaff989ab330f1246b1ad822c.jpg'
  end
end