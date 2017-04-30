json.events do
  json.array! @events, partial: 'events/event_reference', as: :event
end