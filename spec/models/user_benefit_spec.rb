# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserBenefit, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:benefit) }
    it { should belong_to(:rule) }
  end

  describe 'validations' do
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:amount_to_grant) }
    it { should validate_presence_of(:granted_at) }
    it { should validate_presence_of(:status) }
  end

  describe 'scopes' do
    describe '.active_benefits' do
      let!(:active_benefit) { create(:user_benefit, status: 'active') }
      let!(:inactive_benefit) { create(:user_benefit, status: 'inactive') }

      it 'returns only active benefits' do
        expect(described_class.active_benefits).to include(active_benefit)
        expect(described_class.active_benefits).not_to include(inactive_benefit)
      end
    end
  end

  describe 'status' do
    let(:user_benefit) { build(:user_benefit) }

    it 'defaults to active' do
      expect(user_benefit.status).to eq('active')
    end

    it 'can be set to inactive' do
      user_benefit.status = 'inactive'
      expect(user_benefit).to be_valid
      expect(user_benefit.status).to eq('inactive')
    end
  end
end 