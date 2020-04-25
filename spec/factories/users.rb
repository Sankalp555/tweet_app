FactoryGirl.define do
  factory :user do
    first_name     { Faker::Name.name }
    last_name     { Faker::Name.name }
    email         { Faker::Internet.email }
    phone_number  { Faker::PhoneNumber.phone_number }
  end
end