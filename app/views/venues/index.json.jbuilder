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
    json.partial! 'venues/venue_reference', venue: venue

    json.is_open true
    json.point RGeo::GeoJSON.encode(venue.location&.point)
    json.description "You're the first to arrive."

    if venue.location&.google_location
      json.address venue.street
      json.phone venue.phone_number
    end

    if venue['distance']
      json.distance venue['distance']
    end
  end
end