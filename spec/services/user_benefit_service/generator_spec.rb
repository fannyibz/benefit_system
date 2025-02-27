# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserBenefitService::Generator do
  describe '#call' do
    let(:user) { create(:user) }
    let(:benefit) { create(:benefit) }
    let(:rule) { create(:rule, benefit: benefit, amount: 100) }
    let(:generator) { described_class.new(user, rule) }

    context 'when rule matches user conditions' do
      before do
        allow(rule).to receive(:matches_user_conditions?).with(user).and_return(true)
      end

      context 'with no existing benefits' do
        before do
          allow(user).to receive(:existing_user_benefits)
            .with(rule.benefit, Time.current.beginning_of_year)
            .and_return([])
        end

        it 'creates a new user benefit' do
          expect { generator.call }.to change(UserBenefit, :count).by(1)
        end

        it 'creates user benefit with correct attributes' do
          user_benefit = generator.call

          expect(user_benefit).to have_attributes(
            user: user,
            benefit: benefit,
            rule: rule,
            amount: rule.amount,
            amount_to_grant: 0
          )
          expect(user_benefit.granted_at).to be_present
        end
      end

      context 'with existing benefit' do
        let!(:existing_benefit) do
          create(:user_benefit,
                user: user,
                benefit: benefit,
                amount: existing_amount,
                created_at: Time.current.beginning_of_year + 1.day)
        end

        before do
          allow(user).to receive(:existing_user_benefits)
            .with(rule.benefit, Time.current.beginning_of_year)
            .and_return([existing_benefit])
        end

        context 'when new rule amount is higher' do
          let(:existing_amount) { 50 }

          it 'creates a new user benefit with correct amount_to_grant' do
            user_benefit = generator.call

            expect(user_benefit).to have_attributes(
              amount: rule.amount,
              amount_to_grant: rule.amount - existing_amount
            )
          end
        end

        context 'when new rule amount is lower' do
          let(:existing_amount) { 150 }

          it 'creates a new user benefit with zero amount_to_grant' do
            user_benefit = generator.call

            expect(user_benefit).to have_attributes(
              amount: rule.amount,
              amount_to_grant: 0
            )
          end
        end

        context 'when new rule amount is equal' do
          let(:existing_amount) { 100 }

          it 'creates a new user benefit with zero amount_to_grant' do
            user_benefit = generator.call

            expect(user_benefit).to have_attributes(
              amount: rule.amount,
              amount_to_grant: 0
            )
          end
        end
      end
    end

    context 'when rule does not match user conditions' do
      before do
        allow(rule).to receive(:matches_user_conditions?).with(user).and_return(false)
      end

      it 'returns false' do
        expect(generator.call).to be false
      end

      it 'does not create a user benefit' do
        expect { generator.call }.not_to change(UserBenefit, :count)
      end
    end
  end
end 