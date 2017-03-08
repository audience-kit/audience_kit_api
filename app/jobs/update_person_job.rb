class UpdatePersonJob < ApplicationJob
  def perform(person)
    graph = Koala::Facebook::API.new HotMessModels::User.find_by(email_address: 'rickmark@outlook.com').facebook_token

    begin
      person_graph = graph.get_object person.facebook_id

      person.facebook_graph = person_graph
      person.facebook_updated_at = DateTime.now
      person.name = person_graph['name']

      person.save

      events = graph.get_connection person.facebook_id, :events

      events.each do |event|
        begin
          event_model = HotMessModels::Event.find_or_create_by facebook_id: event['id']
          event_graph = graph.get_object event['id']
          event_model.facebook_graph = event_graph

          if event_graph['venue'] and event_graph['venue']['id']
            venue_id = event_graph['venue']['id']

            event_model.venue = HotMessModels::Venue.find_or_initialize_by(facebook_id: venue_id)

            if event_model.venue.new_record?
              event_model.venue.facebook_graph = graph.get_object event_model.venue.facebook_id
              event_model.venue.facebook_updated_at = DateTime.now
              event_model.venue.name = event_model.venue.facebook_graph['name']
              event_model.venue.hidden = true
            end

            event_model.person = person
          else
            puts "No venue for #{event_graph}"
          end

          event_model.update_details_from_facebook
        rescue => ex
          puts "Error updating person #{person.facebook_id}'s event #{ex}"
        end
      end
    rescue => ex
      puts "Failure in updating person #{person.facebook_id} : #{ex}"
    end
  end
end