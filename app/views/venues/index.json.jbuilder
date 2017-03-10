json.envelope @envelope

json.venues do
  json.array! @venues do |venue|
    json.id venue.id
    json.name venue.display_name
    json.facebook_id venue.facebook_id.to_s
    json.is_open venue.is_open?
    json.point RGeo::GeoJSON.encode(venue.location)
    json.description "You're the first to arrive."

    json.photo_url "#{venue_url(venue)}/photo"
    json.hero_banner_url venue.hero_banner_url

    if venue.google_location
      json.address (venue.street || '').gsub!(/,.+/, '')
      json.phone venue.phone
    end

    if venue['distance']
      json.distance venue['distance']
    end
  end
end