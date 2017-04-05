# frozen_string_literal: true

json.locales do
  json.array! @locales do |locale|
    json.id locale.id
    json.name locale.name
    json.label locale.label
  end
end