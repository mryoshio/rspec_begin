FactoryBot.define do
  factory :user do
    email { 'john.doe@example.com' }
    first_name { 'John' }
    last_name  { 'Doe' }
    gender { 'male' }
    member { false }

    trait :nanashi do
      first_name { nil }
      last_name  { nil }
    end
  end
end
