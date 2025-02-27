# frozen_string_literal: true

module UserBenefitService
  class Allocator
    def initialize(user)
      @user = user
    end

    def call
      user_benefits_to_allocate.each do |benefit|
        allocate_benefit(benefit)
      end
    end

    private

    def user_benefits_to_allocate
      Benefit.all.reject do |benefit|
        UserBenefitService::ExistingUserBenefitFinder.new(@user, benefit).call
      end
    end

    def allocate_benefit(benefit)
      highest_amount_rule = benefit.benefit_rule_with_highest_amount(@user)
      return if highest_amount_rule.nil?

      UserBenefitService::Generator.new(@user, highest_amount_rule).call
    end
  end
end