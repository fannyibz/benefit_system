# frozen_string_literal: true

FactoryBot.define do
  factory :reimbursement do
    user
    user_benefit
    amount { 100 }
  end
end 
