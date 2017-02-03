json.venues do
  json.array! @venues do |venue|
    json.id venue.id
    json.name venue.name

    json.is_open venue.is_open?

    if venue.google_location
      json.address venue.google_location['formatted_address']
      json.phone venue.google_location['formatted_phone_number']
    end

    if venue['distance']
      json.distance venue['distance']
    end
  end
end