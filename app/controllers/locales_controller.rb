# frozen_string_literal: true

class LocalesController < ApplicationController
  skip_before_action :authenticate, only: [ :photo ]
  before_filter :require_admin, only: [ :update, :destroy, :create ]

  include Concerns::LocationParameters

  def index
    @locales = Locale.all
  end

  def show
    @locale = Locale.find params[:id]
  end

  def closest
    @locale = Locale.closest location_param

    kinesis :user_location_update, current_user.id, user_id: current_user.id, longatude: @longitude, latitude: @latitude

    render :show
  end

  def events
    @locale = Locale.find params[:id]

    @events = @locale.events

    render 'events/index'
  end

  def photo
    @locale = Locale.find params[:id]
    redirect_to "/photos/#{@locale.location.photo_id}"
  end

  def create

  end

  def update

  end

  def destroy

  end
end