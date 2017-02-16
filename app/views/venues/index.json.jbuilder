json.venues do
  json.array! @venues do |venue|
    json.id venue.id
    json.name venue.name
    json.facebook_id venue.facebook_id.to_s
    json.is_open venue.is_open?

    if venue.google_location
      json.address (venue.street || "").gsub!(/,.+/, "")
      json.phone venue.phone
    end

    if venue['distance']
      json.distance venue['distance']
    end
  end
end