# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Benefit, type: :model do
  describe 'associations' do
    it { should have_many(:rules) }
    it { should have_many(:user_benefits) }
    it { should have_many(:users).through(:user_benefits) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'enums' do
    it { should define_enum_for(:recurrence).with_values(one_time: 0, monthly: 1, yearly: 2) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:benefit)).to be_valid
    end
  end

  describe '#matching_benefit_rule_for' do
    let(:benefit) { create(:benefit) }
    let(:user) { create(:user) }
    let!(:matching_rule) { create(:rule, benefit: benefit) }
    let!(:non_matching_rule) { create(:rule, benefit: benefit) }

    it 'returns the first matching rule' do
      expect(benefit.rules).to include(matching_rule, non_matching_rule)

      allow_any_instance_of(Rule).to receive(:matches_user_conditions?) do |rule, checked_user|
        rule == matching_rule && checked_user == user
      end

      result = benefit.matching_benefit_rule_for(user)
      expect(result).to eq(matching_rule)
    end

    context 'when no rules match' do
      it 'returns nil' do
        expect(benefit.rules).to include(matching_rule, non_matching_rule)
        allow_any_instance_of(Rule).to receive(:matches_user_conditions?).and_return(false)

        result = benefit.matching_benefit_rule_for(user)
        expect(result).to be_nil
      end
    end
  end

  describe '#benefit_rule_with_highest_amount' do
    let(:benefit) { create(:benefit) }
    let(:user) { create(:user) }
    let!(:high_amount_rule) { create(:rule, benefit: benefit, amount: 200) }
    let!(:low_amount_rule) { create(:rule, benefit: benefit, amount: 100) }

    it 'returns the matching rule with highest amount' do
      expect(benefit.rules).to include(high_amount_rule, low_amount_rule)
      allow_any_instance_of(Rule).to receive(:matches_user_conditions?).and_return(true)

      result = benefit.benefit_rule_with_highest_amount(user)
      expect(result).to eq(high_amount_rule)
    end

    context 'when only one rule matches' do
      it 'returns the matching rule' do
        expect(benefit.rules).to include(high_amount_rule, low_amount_rule)

        allow_any_instance_of(Rule).to receive(:matches_user_conditions?) do |rule, checked_user|
          rule == low_amount_rule && checked_user == user
        end

        result = benefit.benefit_rule_with_highest_amount(user)
        expect(result).to eq(low_amount_rule)
      end
    end

    context 'when no rules match' do
      it 'returns nil' do
        expect(benefit.rules).to include(high_amount_rule, low_amount_rule)

        allow_any_instance_of(Rule).to receive(:matches_user_conditions?).and_return(false)

        result = benefit.benefit_rule_with_highest_amount(user)
        expect(result).to be_nil
      end
    end
  end
end
