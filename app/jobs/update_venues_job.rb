class UpdateVenuesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    graph = Koala::Facebook::API.new User.find_by_email_address('rickmark@outlook.com').facebook_token

    Venue.all.each do |venue|
      begin
        object_graph = graph.get_object venue.facebook_id

        venue.facebook_graph = object_graph
        venue.facebook_updated_at = DateTime.new

        events = graph.get_connection venue.facebook_id, :events

        events.each do |event_graph|
          event = Event.find_by(facebook_id: event_graph['id'])

          unless event
            event = Event.new facebook_id: event_graph['id']

            venue.events << event
          end

          event.name = event_graph['name']
          event.facebook_graph = event_graph

          event.start_at = DateTime.parse event_graph['start_time']
          event.end_at = DateTime.parse event_graph['end_time']

          event.save
        end

        venue.save
      rescue => ex
        puts ex
      end
    end
  end
end
