class UpdatePersonJob < ApplicationJob
  def perform(person)
    graph = Koala::Facebook::API.new HotMessModels::User.find_by(email_address: 'rickmark@outlook.com').facebook_token

    puts "Updating Person #{person.name}"
    begin
      person_graph = graph.get_object person.facebook_id

      person.page = HotMessModels::Page.new unless person.page

      person.page.facebook_graph = person_graph
      person.page.name = person_graph['name']

      person.save

      if person_graph['username']
        HotMessModels::SocialLink.find_or_create_by(object_id: person.id, provider: 'facebook', handle: person_graph['username'])
      end

      events = graph.get_connection person.facebook_id, :events
      puts "Person #{person.name} as #{events.count} events"

      events.select { |e| e['start_time'] && DateTime.parse(e['start_time']) < DateTime.now }.each do |event|
        begin
          event_model = HotMessModels::Event.find_or_create_by facebook_id: event['id']

          puts "Updating event => #{event_model['name']}"

          event_graph = graph.get_object event['id']
          event_model.facebook_graph = event_graph

          if event_graph['venue'] and event_graph['venue']['id']
            venue_id = event_graph['venue']['id']

            venue_page = HotMessModels::Page.find_by(facebook_id: venue_id)
            unless venue_page
              venue_page.facebook_graph = graph.get_object event_model.venue.facebook_id
              venue_page.name = event_model.venue.facebook_graph['name']

              venue_page_link = HotMessModels::VenuePage.new(page: venue_page)
              venue_page_link.venue = HotMessModels::Venue.new(hidden: true)
              venue_page_link.save
            else
              venue_page_link = HotMessModels::VenuePage.find_by(page: venue_page)

              if venue_page_link
                event_model.venue = venue_page_link.venue
              else
                venue_page_link = HotMessModels::VenuePage.new(page: venue_page)
                venue_page_link.venue = HotMessModels::Venue.new(hidden: true)
                venue_page_link.save
              end
            end


            event_model.event_people << HotMessModels::EventPerson.new(person: person)
          else
            puts "No venue for #{event_graph['name']}"
          end

          event_model.update_details_from_facebook if event_model.venue
        rescue => ex
          puts "Error updating person #{person.name}'s event #{ex}"
        end
      end
    rescue => ex
      puts "Failure in updating person #{person.name} : #{ex}"
    end
  end
end