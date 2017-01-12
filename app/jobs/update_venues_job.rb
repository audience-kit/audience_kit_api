class UpdateVenuesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    graph = Koala::Facebook::API.new User.find_by_email_address('rickmark@outlook.com').facebook_token

    Venue.all.each do |venue|
      begin
        object_graph = graph.get_object venue.facebook_id

        venue.facebook_graph = object_graph
        venue.save
      rescue => ex
        puts ex
      end
    end
  end
end
