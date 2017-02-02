class EventsController < ApplicationController

  def index
    params.permit :venue_id

    if params[:venue_id]
      @events = Venue.find(params[:venue_id]).events
    else
      @events = Event.all
    end

    @events = @events.where('start_at > ?', DateTime.now).order(start_at: :desc)
  end

  def show
    render json: {}
  end
end