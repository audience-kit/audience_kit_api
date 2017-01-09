class VenuesController < ApplicationController
  def index
    render json: Venue.all
  end

  def show
    render json: Venue.find(params[:id])
  end
end