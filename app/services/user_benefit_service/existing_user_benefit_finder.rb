# frozen_string_literal: true

module UserBenefitService
  class ExistingUserBenefitFinder
    def initialize(user, benefit)
      @user = user
      @benefit = benefit
    end

    def call
      active_user_benefit?
    end

    private

    def active_user_benefit?
      case @benefit.recurrence.to_sym
      when :one_time
        @user.user_benefits.active_benefits.where(benefit: @benefit).exists?
      when :yearly
        # active_benefit = active_benefit?(@benefit)
        # eligible_rule = @user.eligible_rule_for_benefit(@benefit)
        # return false if eligible_rule && eligible_rule.amount > active_benefit.amount
        return false if higher_eligible_rule_amount?(@benefit)

        true
      when :monthly
        @user.existing_user_benefits(@benefit, Time.current.beginning_of_month).exists?
      end
    end

    def active_benefit?(benefit)
      @user.existing_user_benefits(benefit, Time.current.beginning_of_year).first
    end

    def higher_eligible_rule_amount?(benefit)
      active_benefit = active_benefit?(@benefit)
      eligible_rule = @user.eligible_rule_for_benefit(@benefit)
      eligible_rule && eligible_rule.amount > active_benefit.amount
    end
  end
end
