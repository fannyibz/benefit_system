require 'rails_helper'

RSpec.describe Reimbursement, type: :model do
  describe 'associations' do
    it { should belong_to(:user_benefit) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    let(:user) { create(:user) }
    let(:user_benefit) { create(:user_benefit, amount: 1000) }
    subject { build(:reimbursement, user: user, user_benefit: user_benefit) }

    it { should validate_presence_of(:amount) }

    context 'amount validation' do
      before { subject.user_benefit = user_benefit }
      it { should validate_numericality_of(:amount).is_greater_than(0) }
    end
  end

  describe '#sufficient_balance' do
    let(:user) { create(:user) }
    let(:user_benefit) { create(:user_benefit, amount: 1000) }
    let(:reimbursement) { build(:reimbursement, user: user, user_benefit: user_benefit) }

    context 'when amount is less than or equal to available balance' do
      before { reimbursement.amount = 1000 }

      it 'is valid' do
        expect(reimbursement).to be_valid
      end
    end

    context 'when amount exceeds available balance' do
      before { reimbursement.amount = 1500 }

      it 'is invalid' do
        expect(reimbursement).not_to be_valid
        expect(reimbursement.errors[:amount]).to include('ne peut pas dépasser le solde disponible')
      end
    end
  end
end
