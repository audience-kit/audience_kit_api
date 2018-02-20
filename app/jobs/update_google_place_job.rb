class UpdateGooglePlaceJob < ApplicationJob
  def perform
    Locale.all.each do |locale|
      begin
        next unless locale.location

        latitude = locale.location.point.latitude
        longitude = locale.location.point.longitude
        puts "Updating #{locale.display_name} (#{latitude}, #{longitude})"

        timezone = GoogleTimezone.fetch(latitude, longitude, key: Rails.application.secrets.google_api_key)

        puts "Timezone => #{timezone.time_zone_name}"
        locale.timezone_zulu_delta = timezone.raw_offset + timezone.dst_offset if timezone.time_zone_name

        locale.save
      rescue => ex
        puts "Error => #{ex}"

        next
      end
    end

    client = ::GooglePlaces::Client.new(Rails.application.secrets.google_api_key)

    locations  = Location.all

    locations.where('updated_at < ?', 12.hour.ago).each do |place|
      begin
        next unless place.google_place_id

        puts "Updating => #{place.name}"

        spot = client.spot place.google_place_id

        place.google_location = spot

        place.update_location spot['lng'], spot['lat']

        if spot.photos.any?
          photo_url = spot.photos.first.fetch_url(1600)
          photo = Photo.for_url photo_url

          place.photo = photo
        end

        place.save
      rescue => ex
        puts "Error => #{ex}"
      end
    end
  end
end