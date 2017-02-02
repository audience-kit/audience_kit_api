class EventsController < ApplicationController

  def index
    params.permit :venue_id

    if params[:venue_id]
      @events = Venue.find(params[:venue_id]).events
    else
      if params[:locale_id]
        @events = Event.joins(:venue).where(venues: { locale_id: params[:locale_id]})
      else
        @events = Event.includes(:venue)
      end
    end

    @events = @events.where('start_at > ?', DateTime.now).order(start_at: :desc)
  end

  def show
    render json: {}
  end
end