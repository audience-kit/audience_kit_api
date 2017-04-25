json.id venue.id
json.name venue.display_name
json.facebook_id venue.facebook_id.to_s
json.photo_url venue.page.photo&.cdn_url
json.hero_url venue.location&.photo.cdn_url