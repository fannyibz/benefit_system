# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rule, type: :model do
  describe 'associations' do
    it { should belong_to(:benefit) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:amount) }
  end

  describe 'stored attributes' do
    it { should respond_to(:min_seniority) }
    it { should respond_to(:max_seniority) }
    it { should respond_to(:location) }
    it { should respond_to(:contract_type) }
  end

  describe '#matches_user_conditions?' do
    let(:rule) { create(:rule) }
    let(:user) { create(:user) }

    context 'when conditions are empty' do
      it 'returns false' do
        expect(rule.matches_user_conditions?(user)).to be false
      end
    end

    context 'with seniority conditions' do
      let(:user) { create(:user, start_date: 3.years.ago) }

      it 'matches when user seniority is within range' do
        rule.update(conditions: { min_seniority: 2, max_seniority: 5 })
        expect(rule.matches_user_conditions?(user)).to be true
      end

      it 'does not match when user seniority is too low' do
        rule.update(conditions: { min_seniority: 5 })
        expect(rule.matches_user_conditions?(user)).to be false
      end

      it 'does not match when user seniority is too high' do
        rule.update(conditions: { max_seniority: 2 })
        expect(rule.matches_user_conditions?(user)).to be false
      end

      it 'matches with only min_seniority' do
        rule.update(conditions: { min_seniority: 2 })
        expect(rule.matches_user_conditions?(user)).to be true
      end

      it 'matches with only max_seniority' do
        rule.update(conditions: { max_seniority: 5 })
        expect(rule.matches_user_conditions?(user)).to be true
      end
    end

    context 'with location condition' do
      let(:user) { create(:user, location: 'Paris') }

      it 'matches when locations match' do
        rule.update(conditions: { location: 'Paris' })
        expect(rule.matches_user_conditions?(user)).to be true
      end

      it 'does not match when locations differ' do
        rule.update(conditions: { location: 'London' })
        expect(rule.matches_user_conditions?(user)).to be false
      end
    end

    context 'with contract_type condition' do
      let(:user) { create(:user, contract_type: 'full_time') }

      it 'matches when contract types match' do
        rule.update(conditions: { contract_type: 'full_time' })
        expect(rule.matches_user_conditions?(user)).to be true
      end

      it 'does not match when contract types differ' do
        rule.update(conditions: { contract_type: 'part_time' })
        expect(rule.matches_user_conditions?(user)).to be false
      end
    end

    context 'with multiple conditions' do
      let(:user) { create(:user, 
                         start_date: 3.years.ago,
                         location: 'Paris',
                         contract_type: 'full_time') }

      it 'matches when all conditions are met' do
        rule.update(conditions: {
          min_seniority: 2,
          max_seniority: 5,
          location: 'Paris',
          contract_type: 'full_time'
        })
        expect(rule.matches_user_conditions?(user)).to be true
      end

      it 'does not match when any condition fails' do
        rule.update(conditions: {
          min_seniority: 2,
          max_seniority: 5,
          location: 'London',
          contract_type: 'full_time'
        })
        expect(rule.matches_user_conditions?(user)).to be false
      end
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:rule)).to be_valid
    end
  end
end 