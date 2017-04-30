# frozen_string_literal: true

json.id event.id
json.name event.display_name
json.start_at event.start_at
json.end_at event.end_at
json.facebook_id event.facebook_id
json.cover_photo_url event.cover_photo&.cdn_url
json.rsvp @rsvp&.state || 'unsure'