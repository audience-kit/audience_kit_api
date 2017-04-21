# frozen_string_literal: true

json.envelope @envelope

if @locale
  json.locale do
    json.id @locale.id
    json.name @locale.name
    json.label @locale.label
  end
end

json.venues do
  json.array! @venues do |venue|
    json.id venue.id
    json.name venue.display_name
    json.facebook_id venue.facebook_id.to_s
    json.is_open true
    json.point RGeo::GeoJSON.encode(venue.location)
    json.description "You're the first to arrive."

    json.photo_url venue.page.photo&.cdn_url
    json.hero_url venue.location&.photo.cdn_url

    if venue.location&.google_location
      json.address venue.street
      json.phone venue.phone_number
    end

    if venue['distance']
      json.distance venue['distance']
    end
  end
end