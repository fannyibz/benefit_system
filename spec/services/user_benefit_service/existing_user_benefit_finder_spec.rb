# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserBenefitService::ExistingUserBenefitFinder do
  describe '#call' do
    let(:user) { create(:user) }
    let(:benefit) { create(:benefit) }
    let(:rule) { create(:rule, benefit: benefit) }
    let(:finder) { described_class.new(user, benefit) }

    context 'with one_time benefit' do
      before do
        allow(benefit).to receive(:recurrence).and_return('one_time')
      end

      context 'when user has an active benefit' do
        let!(:active_benefit) { create(:user_benefit, user: user, benefit: benefit, status: :active) }

        it 'returns true' do
          expect(finder.call).to be true
        end
      end

      context 'when user has no active benefit' do
        let!(:inactive_benefit) { create(:user_benefit, user: user, benefit: benefit, status: :inactive) }

        it 'returns false' do
          expect(finder.call).to be false
        end
      end
    end

    context 'with yearly benefit' do
      before do
        allow(benefit).to receive(:recurrence).and_return('yearly')
      end

      context 'when user has an active benefit this year' do
        let!(:active_benefit) do
          create(:user_benefit,
                 user: user,
                 benefit: benefit,
                 status: :active,
                 amount: 100,
                 created_at: Time.current.beginning_of_year + 1.month)
        end

        context 'when eligible rule amount is lower than active benefit' do
          before do
            allow(user).to receive(:eligible_rule_for_benefit).with(benefit).and_return(rule)
            allow(rule).to receive(:amount).and_return(50)
          end

          it 'returns true' do
            expect(finder.call).to be true
          end
        end

        context 'when eligible rule amount is higher than active benefit' do
          before do
            allow(user).to receive(:eligible_rule_for_benefit).with(benefit).and_return(rule)
            allow(rule).to receive(:amount).and_return(150)
          end

          it 'returns false' do
            expect(finder.call).to be false
          end
        end

        context 'when there is no eligible rule' do
          before do
            allow(user).to receive(:eligible_rule_for_benefit).with(benefit).and_return(nil)
          end

          it 'returns true' do
            expect(finder.call).to be true
          end
        end
      end

      context 'when user has no active benefit this year' do
        let!(:old_benefit) do
          create(:user_benefit,
                 user: user,
                 benefit: benefit,
                 status: :active,
                 created_at: 1.year.ago)
        end

        it 'returns false' do
          expect(finder.call).to be false
        end
      end
    end

    context 'with monthly benefit' do
      before do
        allow(benefit).to receive(:recurrence).and_return('monthly')
      end

      context 'when user has an active benefit this month' do
        let!(:active_benefit) do
          create(:user_benefit,
                 user: user,
                 benefit: benefit,
                 status: :active,
                 created_at: Time.current.beginning_of_month + 1.day)
        end

        it 'returns true' do
          expect(finder.call).to be true
        end
      end

      context 'when user has no active benefit this month' do
        let!(:old_benefit) do
          create(:user_benefit,
                 user: user,
                 benefit: benefit,
                 status: :active,
                 created_at: 1.month.ago)
        end

        it 'returns false' do
          expect(finder.call).to be false
        end
      end
    end
  end
end
