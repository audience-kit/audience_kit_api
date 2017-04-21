# frozen_string_literal: true

json.people do
  json.array! @people do |person|
    json.id person.id
    json.name person.display_name
    json.facebook_id person.facebook_id
    json.photo_url person.page.photo.cdn_url

    json.is_liked @user_likes[person.page] ? true : false
  end
end