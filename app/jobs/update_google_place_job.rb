class UpdateGooglePlaceJob < ApplicationJob
  def perform
    begin
      client = ::GooglePlaces::Client.new(Rails.application.secrets.google_api_key)

      locations  = HotMessModels::Location.all

      locations.each do |place|
        next unless place.google_place_id

        puts "Updating => #{place.name}"

        spot = client.spot place.google_place_id

        place.google_location = spot
        place.google_updated_at = DateTime.now

        place.update_location spot['lng'], spot['lat']

        place.save
      end

      HotMessModels::Venue.where('location_id IS NOT NULL').each { |v| v.update_data }
    rescue => ex
      puts "Error => #{ex}"
    end
  end
end