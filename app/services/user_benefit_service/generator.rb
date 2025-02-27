# frozen_string_literal: true

module UserBenefitService
  class Generator
    def initialize(user, rule)
      @user = user
      @rule = rule
    end

    def call
      return false unless @rule.matches_user_conditions?(@user)

      @user.user_benefits.create!(
        benefit: @rule.benefit,
        rule: @rule,
        amount: @rule.amount,
        granted_at: Time.current,
        amount_to_grant: calculate_amount_to_grant(@rule)
      )
    end

  private

    def calculate_amount_to_grant(rule)
      existing_benefit_amount = existing_rule_benefit_amount(rule)
      return 0 unless existing_benefit_amount.present? && rule.amount > existing_benefit_amount
      
      rule.amount - existing_benefit_amount
    end

    def existing_rule_benefit_amount(rule)
      @user.existing_user_benefits(rule.benefit, Time.current.beginning_of_year).first&.amount
    end
  end
end
