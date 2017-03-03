class LocalesController < ApplicationController
  include Concerns::LocationParameters

  def index
    Locale.all
  end

  def show
    Locale.find params[:id]
  end

  def closest
    @locale = Locale.closest location_param

    render :show
  end
end