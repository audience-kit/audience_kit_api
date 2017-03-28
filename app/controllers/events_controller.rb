class EventsController < ApplicationController
  def index
    params.permit :venue_id

    @events = HotMessModels::Event.future.includes([ { event_people: { person: :page } }, { venue: :pages } ])
  end

  def show
    @event = HotMessModels::Event.find params[:id]

    kinesis :event_view, @event.id, user_id: user.id, id: @event.id
  end
end