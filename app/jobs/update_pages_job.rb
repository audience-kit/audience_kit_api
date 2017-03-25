class UpdatePagesJob < ApplicationJob
  def perform
    puts 'Performing page update'
    app_token = HotMessModels::Concerns::Facebook.oauth.get_app_access_token

    HotMessModels::Page.where('updated_at < ? and hidden IS FALSE', 12.hour.ago).order(updated_at: :desc).each do |page|
      puts "Updating page #{page.name}"
      begin
        user_token = HotMessModels::User.where('facebook_token IS NOT NULL').order('RANDOM()').first.facebook_token

        graph_client = Koala::Facebook::API.new app_token
        page.requires_user_token = false
        object_graph = nil

        begin
          object_graph = graph_client.get_object page.facebook_id
        rescue => ex
          puts "Fallback to user token => #{ex}"
          graph_client = Koala::Facebook::API.new user_token
          object_graph = graph_client.get_object page.facebook_id
          page.requires_user_token = true
        end

        page.update_graph object_graph, client: graph_client
        page.save

        if page.venue and page.venue.hidden
          events = []
        else
          events = graph_client.get_connection page.facebook_id, :events
          puts "Object #{page.name} has #{events.count} events"
        end

        events.select { |e| e['start_time'] && DateTime.parse(e['start_time']) > DateTime.now }.each { |event| update_events page, event, graph_client }

        if page.person
          if object_graph['username']
            HotMessModels::SocialLink.find_or_create_by(object_id: page.person.id, provider: 'facebook', handle: object_graph['username'])
          end
        end

        page.venues.each do |venue|
          venue.update_data
        end
      rescue => ex
        puts "Error updating page #{page.name} (#{page.facebook_id}) => #{ex}"
      end
    end
  end

  def update_events(page, event, graph_client)
    begin
      event_model = HotMessModels::Event.find_or_create_by facebook_id: event['id']

      puts "Updating event => #{event_model['name']}"

      event_graph = graph_client.get_object event['id']
      event_model.facebook_graph = event_graph

      if event_graph['venue'] and event_graph['venue']['id']
        venue_id = event_graph['venue']['id']

        venue_page = HotMessModels::Page.find_by(facebook_id: venue_id)
        unless venue_page
          venue_page.facebook_graph = graph_client.get_object event_model.venue.facebook_id
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

        # TODO: This is a kluge
        event_model.event_people << HotMessModels::EventPerson.new(person: page.person) if page.person and not event_model.event_people.any?
      else
        puts "No venue for #{event_graph['name']} (#{event_graph['id']})"
      end

      event_model.update_details_from_facebook if event_model.venue
    rescue => ex
      puts "Error updating object #{page.name}'s event #{ex}"
    end
  end
end