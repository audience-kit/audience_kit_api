# frozen_string_literal: true

json.friends do
  json.array! @friends do |friend|
    json.id friend.id
    json.name friend.name
    json.facebook_id friend.facebook_id
  end
end