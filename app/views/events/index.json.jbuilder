# frozen_string_literal: true

json.sections do
  @sections.each do |section|
    json.set! section[:name] do
      json.title section[:title]
      json.events do
        json.array! section[:events] do |event|
          json.partial! 'events/event_reference', as: :event
          json.is_featured section[:featured]
        end
      end
    end
  end
end