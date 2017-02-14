# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    start_time DateTime.new.at_beginning_of_hour().advance(days: 7)
    end_time DateTime.new.at_beginning_of_hour().advance(days: 7, hours: 4)
    name "Some Really Cool Event"
    pictures { [ build(:picture, type: :normal), build(:picture, type: :large), build(:picture, type: :small), build(:picture, type: :square)  ] }
    venue

    factory :past_event do
      start_time DateTime.new.at_beginning_of_hour().advance(days: -7)
      end_time DateTime.new.at_beginning_of_hour().advance(days: -7, hours: 4)
    end
  end
end
