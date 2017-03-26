class UpdateGooglePlaceJob < ApplicationJob
  def perform
    begin
      client = ::GooglePlaces::Client.new(Rails.application.secrets.google_api_key)

      locations  = HotMessModels::Location.all

      locations.where('updated_at < ?', 12.hour.ago).each do |place|
        next unless place.google_place_id

        puts "Updating => #{place.name}"

        spot = client.spot place.google_place_id

        place.google_location = spot
        place.google_updated_at = DateTime.now

        place.update_location spot['lng'], spot['lat']

        if spot.photos.any?
          place.photo = HotMessModels::Photo.for_url spot.photos.first.fetch_url(1600)
        end

        place.save
      end
    rescue => ex
      puts "Error => #{ex}"
    end
  end
end