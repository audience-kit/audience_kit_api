class UpdatePagesJob < ApplicationJob
  EVENT_FIELDS = %w[ticket_uri owner name cover start_time end_time place].freeze

  def perform
    puts 'Performing page update'
    app_token = Concerns::Facebook.oauth.get_app_access_token

    Page.where('updated_at < ? and hidden IS FALSE', 12.hour.ago).order(updated_at: :desc).each do |page|
      puts "Updating page #{page.name}"
      begin
        user_token = User.where('facebook_token IS NOT NULL').order('RANDOM()').first.facebook_token

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

        if page.venue && !page.venue.hidden
          events = nil
        else
          events = graph_client.get_connection page.facebook_id, :events
          puts "Object #{page.name} has #{events.count} events"
        end

        if page.person
          if object_graph['username']
            page.person.social_links.find_or_create_by(provider: 'facebook', handle: object_graph['username'])
          end

          events = graph_client.get_connection page.facebook_id, :events
        end

        while events
          events.select { |e| e['start_time'] && DateTime.parse(e['start_time']) > DateTime.now }.each do |event|
            update_events page, event, graph_client
          end
          events = events.next_page
        end

        page.venue&.update_data
      rescue => ex
        puts "Error updating page #{page.name} (#{page.facebook_id}) => #{ex}"
      end
    end
  end

  def update_events(page, event, graph_client)
    event_model = Event.find_or_create_by facebook_id: event['id']

    puts "Updating event => #{event_model['name']}"

    event_graph = graph_client.get_object event['id'], fields: EVENT_FIELDS
    event_model.facebook_graph = event_graph

    if event_graph['place']
      venue_id = event_graph['place']['id']

      venue_page = Page.page_for_facebook_id(venue_id, true)

      event_model.venue = venue_page.venue || Venue.new(hidden: true, page: venue_page) if venue_page
    else
      puts "No venue for #{event_graph['name']} (#{event_graph['id']})"
    end

    if event_graph['cover']
      event_model.cover_photo = Photo.for_url event_graph['cover']['source']
    end

    event_model.update_details_from_facebook if event_model.venue

    event_model.update_tickets

    EventPerson.find_or_create_by(person: page.person, event: event_model, role: 'host') if page.person
  rescue => ex
    puts "Error updating object #{page.name}'s event #{ex.to_s}\n#{ex.backtrace}"
  end
end