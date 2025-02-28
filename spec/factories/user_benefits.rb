# frozen_string_literal: true

FactoryBot.define do
  factory :user_benefit do
    user
    benefit
    rule
    amount { 100 }
    amount_to_grant { 100 }
    granted_at { Time.current }
    status { 'active' }
  end
end
