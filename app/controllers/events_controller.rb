class EventsController < ApplicationController
  def index
    params.permit :venue_id

    if params[:venue_id]
      @events = HotMessModels::Venue.find(params[:venue_id]).events
    elsif params[:locale_id]
      @events = HotMessModels::Locale.find(params[:locale_id]).events
    else
      @events = HotMessModels::Event.all
    end

    @events = @events.future
  end

  def show
    @event = HotMessModels::Event.find params[:id]
  end
end