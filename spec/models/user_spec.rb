# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:location) }
    it { should validate_presence_of(:contract_type) }
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(6) }

    describe 'email validations' do
      subject { build(:user) }

      it { should validate_uniqueness_of(:email).case_insensitive }

      context 'when email is invalid' do
        it 'is not valid' do
          user = build(:user)
          user.email = 'invalid_email'
          expect(user).not_to be_valid
        end
      end
      context 'when email is valid' do
        it 'is valid' do
          user = build(:user)
          user.email = 'valid@example.com'
          expect(user).to be_valid
        end
      end
    end
  end

  describe '#seniority' do
    it 'returns 0 when start_date is nil' do
      user = build(:user, start_date: nil)
      expect(user.seniority).to eq(0)
    end

    it 'returns correct seniority for a user' do
      travel_to Time.zone.local(2024, 1, 1, 12, 0, 0) do
        user = create(:user, start_date: Date.new(2019, 1, 1))
        expect(user.seniority).to eq(5)
      end
    end

    it 'returns 0 for employees less than a year' do
      travel_to Time.zone.local(2024, 1, 1, 12, 0, 0) do
        user = create(:user, start_date: Date.new(2023, 7, 1))
        expect(user.seniority).to eq(0)
      end
    end
  end

  describe '#eligible_rule_for_benefit' do
    let(:user) { create(:user) }
    let(:benefit) { create(:benefit) }
    let(:matching_rule) { create(:rule, benefit: benefit) }
    let(:non_matching_rule) { create(:rule, benefit: benefit) }

    before do
      allow(matching_rule).to receive(:matches_user_conditions?).with(user).and_return(true)
      allow(non_matching_rule).to receive(:matches_user_conditions?).with(user).and_return(false)
      benefit.rules << [matching_rule, non_matching_rule]
    end

    it 'returns the first matching rule for the benefit' do
      expect(user.eligible_rule_for_benefit(benefit)).to eq(matching_rule)
    end

    context 'when no rules match' do
      before do
        allow(matching_rule).to receive(:matches_user_conditions?).with(user).and_return(false)
      end

      it 'returns nil' do
        expect(user.eligible_rule_for_benefit(benefit)).to be_nil
      end
    end

    context 'when benefit has no rules' do
      let(:empty_benefit) { create(:benefit) }

      it 'returns nil' do
        expect(user.eligible_rule_for_benefit(empty_benefit)).to be_nil
      end
    end
  end
end
