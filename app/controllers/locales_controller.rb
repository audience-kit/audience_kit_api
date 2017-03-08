class LocalesController < ApplicationController
  include Concerns::LocationParameters

  def index
    HotMessModels::Locale.all
  end

  def show
    HotMessModels::Locale.find params[:id]
  end

  def closest
    @locale = HotMessModels::Locale.closest location_param

    render :show
  end
end