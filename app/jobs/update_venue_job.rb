class UpdateVenueJob < ApplicationJob
  def perform(venue)
    graph = Koala::Facebook::API.new HotMessModels::User.where('facebook_token IS NOT NULL').order('RANDOM()').first.facebook_token

    begin
      return unless venue.page

      puts "Updating => #{venue.name}"
      object_graph = graph.get_object venue.page.facebook_id

      venue.page.facebook_graph = object_graph
      venue.page.name = object_graph['name']
      venue.update_data

      if object_graph['username']
        HotMessModels::SocialLink.find_or_create_by(object_id: venue.id, provider: 'facebook', handle: object_graph['username'])
      end

      events = []
      events = graph.get_connection venue.facebook_id, :events unless venue.hidden

      events.select { |e| e['start_time'] && DateTime.parse(e['start_time']) < DateTime.now }.each do |event_graph|
        begin
          event = HotMessModels::Event.find_by(facebook_id: event_graph['id'])

          unless event
            event = HotMessModels::Event.new facebook_id: event_graph['id']

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