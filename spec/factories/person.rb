# frozen_string_literal: true

FactoryGirl.define do
  factory :person do

    facebook_id 10_203_595_242_113_373

    name 'Johnny Appleseed'
    is_public false

    factory :public_person do
      is_public true
    end
  end
end
