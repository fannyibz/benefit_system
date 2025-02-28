# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserBenefitService::Allocator do
  describe '#call' do
    let(:user) { create(:user) }
    let(:benefit) { create(:benefit) }
    let(:rule) { create(:rule, benefit: benefit, conditions: { location: user.location }) }
    let(:allocator) { described_class.new(user) }

    before do
      allow(user).to receive(:eligible_rule_for_benefit).with(benefit).and_return(rule)
      allow(Benefit).to receive(:all).and_return([benefit])
    end

    context 'when user has no existing benefits' do
      before do
        allow_any_instance_of(UserBenefitService::ExistingUserBenefitFinder)
          .to receive(:call)
          .and_return(nil)
      end

      it 'allocates new benefits' do
        generator_double = double(call: true)
        expect(UserBenefitService::Generator)
          .to receive(:new)
          .with(user, rule)
          .and_return(generator_double)

        allocator.call
      end
    end

    context 'when user has existing benefits' do
      let(:active_benefit) { create(:user_benefit, user: user, benefit: benefit, amount: 100) }

      before do
        allow_any_instance_of(UserBenefitService::ExistingUserBenefitFinder)
          .to receive(:call)
          .and_return(active_benefit)
      end

      context 'when eligible rule amount is higher than active benefit' do
        before do
          allow(rule).to receive(:amount).and_return(150)
        end

        it 'does not allocate new benefit' do
          expect(UserBenefitService::Generator).not_to receive(:new)
          allocator.call
        end
      end

      context 'when eligible rule amount is lower than active benefit' do
        before do
          allow(rule).to receive(:amount).and_return(50)
        end

        it 'does not allocate new benefit' do
          expect(UserBenefitService::Generator).not_to receive(:new)
          allocator.call
        end
      end

      context 'when there is no eligible rule' do
        before do
          allow(user).to receive(:eligible_rule_for_benefit).with(benefit).and_return(nil)
        end

        it 'does not allocate new benefit' do
          expect(UserBenefitService::Generator).not_to receive(:new)
          allocator.call
        end
      end
    end
  end
end
