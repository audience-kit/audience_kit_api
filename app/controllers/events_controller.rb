class EventsController < ApplicationController
  def index
    params.permit :venue_id

    @events = HotMessModels::Event.future.includes([ { event_people: { person: :page } }, { venue: :pages } ])
  end

  def show
    @event = HotMessModels::Event.find params[:id]

    kinesis :event_view, @event.id, user_id: current_user.id, id: @event.id
  end

  def rsvp
    params.require :state

    @event = HotMessModels::Event.find params[:id]

    @rsvp = @event.rsvps.find_or_initialize_by user: current_user

    @rsvp.state = params[:state]


    graph_client = Koala::Facebook::API.new current_user.facebook_token

    case params[:state]
      when 'attending'
        graph_client.put_object @event.facebook_id, :attending
      when 'unsure'
      when 'maybe'
        graph_client.put_object @event.facebook_id, :maybe
      when 'declined'
        graph_client.put_object @event.facebook_id, :declined
      else
        return render status: :bad_request
    end

    @rsvp.save


    render 'events/show'
  end
end