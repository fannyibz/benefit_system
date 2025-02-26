# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Benefit, type: :model do
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
end 