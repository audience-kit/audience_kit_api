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

        if spot.photos.any?
          photo = spot.photos.first

          place.hero_url = photo.fetch_url 1600
          response =  Net::HTTP.get_response(URI(place.hero_url))
          place.hero_image = response.body
          place.hero_mime = response['Content-Type']
        end

        place.save
      end
    rescue => ex
      puts "Error => #{ex}"
    end
  end
end