# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :address do
    address_line "1020 N Homestead"
    city "Spokane"
    state "WA"
    zip 99019
  end
end
