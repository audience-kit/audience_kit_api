json.events do
  json.array! @events, partial: 'events/event_reference', as: :event
end

json.sections do
  (@sections || []).each do |section|
    json.set! section[:name] do
      json.title section[:title]
      json.events do
        json.array! section[:events], partial: 'events/event_reference', as: :event
      end
    end
  end
end