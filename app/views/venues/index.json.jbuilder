json.venues do
  json.array! @venues do |venue|
    json.id venue.id
    json.name venue.name

    if venue['distance']
      json.distance venue['distance']
    end
  end
end