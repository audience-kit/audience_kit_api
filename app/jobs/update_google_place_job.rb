class UpdateGooglePlaceJob < ApplicationJob
  def perform

    client = GooglePlaces::Client.new(Rails.application.secrets.google_api_key)

    (Venue.all + Locale.all).each do |place|
      next unless place.google_place_id

      spot = client.spot place.google_place_id

      place.google_location = spot.to_json
      place.save
    end
  end
end