FactoryGirl.define do
  factory :person do

    facebook_id     10203595242113373

    name "Jonny Appleseed"
    is_public false
    
    factory :public_person do
      is_public true
    end
  end
end