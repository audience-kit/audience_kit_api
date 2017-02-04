class UpdateGooglePlaceJob < ApplicationJob
  def perform
    client = GooglePlaces::Client.new(Rails.application.secrets.google_api_key)

    locations = Venue.all + Locale.all
    locations.each do |place|
      next unless place.google_place_id

      puts "Updating => #{place.name}"

      spot = client.spot place.google_place_id

      place.google_location = spot
      place.location = RGeo::Geographic.simple_mercator_factory.point spot['lng'], spot['lat']
      place.google_updated_at = DateTime.now

      place.save
    end

    Venue.all.each do |venue|
      next unless venue.google_location

      venue.street = venue.google_location['formatted_address']
      venue.phone = venue.google_location['formatted_phone_number']

      venue.save
    end
  end
end