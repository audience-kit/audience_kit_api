class UpdatePeopleJob < ApplicationJob
  def perform
    graph = Koala::Facebook::API.new User.find_by(email_address: 'rickmark@outlook.com').facebook_token

    Person.all.each do |person|
      begin
        person_graph = graph.get_object person.facebook_id

        person.facebook_graph = person_graph
        person.facebook_updated_at = DateTime.now

        person.save

        events = graph.get_connection person.facebook_id, :events

        events.each do |event|
          begin
            event_model = Event.find_or_create_by facebook_id: event['id']

            event_model.facebook_graph = graph.get_object event['id']
            event_model.save
          rescue => ex
            puts "Error updating person #{person.facebook_id}'s event #{ex}"
          end
        end
      rescue => ex
        puts "Failure in updating person #{person.facebook_id} : #{ex}"
      end
    end
  end
end