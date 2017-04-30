# frozen_string_literal: true

class EventsController < ApplicationController
  def index
    params.permit :venue_id

    @events = Locale.find(params[:locale_id]).events.future.includes(venue: :page)

    @sections = []

    @sections << { name: :recommended,
                   events: @events.where('cover_photo_id IS NOT NULL').take(2),
                   title: 'Featured',
                   featured: true }

    @sections << { name: :upcoming,
                   events: @events,
                   title: 'Upcoming',
                   featured: false }
  end

  def show
    @event = Event.find params[:id]

    @rsvp = @event.rsvps.find_by(user: current_user)

    kinesis :event_view, @event.id, user_id: current_user.id, id: @event.id
  end

  def rsvp
    params.require :state

    @event = Event.find params[:id]

    @rsvp = UserRSVP.find_or_initialize_by user: current_user, event: @event
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