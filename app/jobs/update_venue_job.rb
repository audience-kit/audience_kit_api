class UpdateVenueJob < ApplicationJob
  def perform(venue)
    graph = Koala::Facebook::API.new HotMessModels::User.find_by(email_address: 'rickmark@outlook.com').facebook_token

    begin
      return unless venue.page

      puts "Updating => #{venue.name}"
      object_graph = graph.get_object venue.page.facebook_id

      venue.page.facebook_graph = object_graph
      venue.page.name = object_graph['name']
      venue.update_data

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