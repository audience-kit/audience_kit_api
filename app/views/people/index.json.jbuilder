# frozen_string_literal: true

json.people do
  json.array! @people do |person|
    json.partial! 'people/person_reference', person: person
  end
end