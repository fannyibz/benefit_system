FactoryBot.define do
  factory :rule do
    name { "Rule" }
    amount { 100 }
    benefit
    conditions { {} }

    trait :with_seniority_and_paris do
      conditions { { seniority: 5, location: 'Paris' } }
      amount { 2000 }
    end

    trait :with_location_and_notparis do
      conditions { { location: 'Lyon' } }
      amount { 1000 }
    end

    trait :with_contract_type do
      conditions { { contract_type: 'Stage' } }
      amount { 500 }
    end
  end
end
