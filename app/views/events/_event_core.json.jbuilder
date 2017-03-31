json.id event.id
json.name event.display_name
json.start_at event.start_at
json.end_at event.end_at
json.facebook_id event.facebook_id
json.rsvp @event_rsvp&.state || 'unsure' if @event_rsvp