json.people do
  json.array! @people do |person|
    json.id person.id
    json.name person.display_name
    json.facebook_id person.facebook_id
  end
end