FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { 'password123' }
    start_date { Date.current }
    location { Faker::Address.city }
    contract_type { 'CDI' }  
  end

  trait :senior do
    start_date { 5.years.ago }
  end

  trait :junior do
    start_date { 6.months.ago }
  end
end 