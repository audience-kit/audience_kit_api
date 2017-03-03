class EventsController < ApplicationController
  def index
    params.permit :venue_id

    if params[:venue_id]
      @events = Venue.find(params[:venue_id]).events
    elsif params[:locale_id]
      @events = Locale.find(params[:locale_id]).events
    else
      @events = Event.all
    end

    @events = @events.future
  end

  def show
    @event = Event.find params[:event_id]
  end
end