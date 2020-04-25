Fabricator(:user) do
  first_name            "Test"
  last_name            "Test"
  organization_id         3
  email                 { Faker::Internet.email }
  password              "password"
  password_confirmation "password"
end