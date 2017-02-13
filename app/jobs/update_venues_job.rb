class UpdateVenuesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # graph = Koala::Facebook::API.new Concerns::Facebook.oauth.get_app_access_token
    graph = Koala::Facebook::API.new User.find_by(email_address: 'rickmark@outlook.com').facebook_token


    Venue.all.order(facebook_updated_at: :desc).each do |venue|
      begin
        next unless venue.facebook_id

        puts "Updating => #{venue.name}"
        object_graph = graph.get_object venue.facebook_id

        venue.facebook_graph = object_graph
        venue.facebook_updated_at = DateTime.now
        venue.name = object_graph['name']
        venue.update_data

        events = graph.get_connection venue.facebook_id, :events

        events.each do |event_graph|
          begin
            event = Event.find_by(facebook_id: event_graph['id'])

            unless event
              event = Event.new facebook_id: event_graph['id']

              venue.events << event
            end

            event.name = event_graph['name']
            event.facebook_graph = graph.get_object event_graph['id']

            event.start_at = DateTime.parse event_graph['start_time'] if event_graph['start_time']
            event.end_at = DateTime.parse event_graph['end_time'] if event_graph['end_time']

            event.save
          rescue => ex
            puts ex
          end
        end

        venue.save
      rescue => ex
        puts ex
      end
    end
  end
end
