class EventsController < ApplicationController

  def index
    params.permit :venue_id

    if params[:venue_id]
      @events = Venue.find(params[:venue_id]).events
    else
      @events = Event.includes(:venue)
      @events = @events.where(venues: { locale_id: params[:locale_id]}) if params[:locale_id]
    end

    @events = @events.where('start_at > ? OR end_at > ?', DateTime.now, DateTime.now).order(start_at: :asc)
  end

  def show
    render json: {}
  end
end