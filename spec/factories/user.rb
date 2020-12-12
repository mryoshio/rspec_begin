FactoryBot.define do
  factory :user do
    email { 'john.doe@example.com' }
    first_name { 'John' }
    last_name  { 'Doe' }
    gender { 'male' }
    member { false }
  end
end
