class UpdateGooglePlaceJob < ApplicationJob
  def perform

    client = GooglePlaces::Client.new(Rails.application.secrets.google_api_key)

    (Venue.all + Locale.all).each do |place|
      next unless place.google_place_id

      puts "Updating => #{place.name}"

      spot = client.spot place.google_place_id

      place.google_location = spot
      place.location = "POINT(#{spot['lng']} #{spot['lat']})"
      place.google_updated_at = DateTime.now

      place.save
    end
  end
end