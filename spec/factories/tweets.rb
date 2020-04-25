FactoryGirl.define do
  factory :tweet do
    message  { Faker::Internet.text }
  end
end