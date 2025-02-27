# frozen_string_literal: true

class Benefit < ApplicationRecord
  has_many :rules
  has_many :user_benefits
  has_many :users, through: :user_benefits

  validates :name, presence: true

  enum :recurrence, { one_time: 0, monthly: 1, yearly: 2 }

  def matching_benefit_rule_for(user)
    rules.find { |rule| rule.matches_user_conditions?(user) }
  end

  def benefit_rule_with_highest_amount(user)
    rules.select { |rule| rule.matches_user_conditions?(user) }.max_by(&:amount)
  end
end 