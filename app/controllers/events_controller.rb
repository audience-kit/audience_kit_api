class EventsController < ApplicationController
  def index
    params.permit :venue_id

    if params[:venue_id]
      @events = HotMessModels::Venue.find(params[:venue_id]).events.includes([ { event_people: { person: :page } }, { venue: :pages } ])
    elsif params[:locale_id]
      @events = HotMessModels::Locale.find(params[:locale_id]).events.includes([ { event_people: { person: :page } }, { venue: :pages } ])
    else
      @events = HotMessModels::Event.includes([ { event_people: { person: :page } }, { venue: :pages } ])
    end

    @events = @events.future
  end

  def show
    @event = HotMessModels::Event.find params[:id]

    kinesis :event_view, @event.id, user_id: user.id, id: @event.id
  end
end