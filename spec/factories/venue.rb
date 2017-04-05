# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :venue do
    name 'Everafter'
    phone '+15098921403'
    location Location.new street: '556 Harvard Ave E', city: 'Seattle', state: 'WA', zip: '98102'
    about "Seattle's longest running and largest gay club"
    description 'Huge dance floor and spectacular entertainment for everyone!'
    pictures do
      [
        build(:picture, type: :normal),
        build(:picture, type: :large),
        build(:picture, type: :small),
        build(:picture, type: :square)
      ]
    end
  end
end
