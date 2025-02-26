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
    it 'allows access to seniority' do
      rule = build(:rule, conditions: { seniority: 5 })
      expect(rule.seniority).to eq(5)
    end

    it 'allows access to location' do
      rule = build(:rule, conditions: { location: 'Paris' })
      expect(rule.location).to eq('Paris')
    end

    it 'allows access to contract_type' do
      rule = build(:rule, conditions: { contract_type: 'full_time' })
      expect(rule.contract_type).to eq('full_time')
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:rule)).to be_valid
    end
  end
end 