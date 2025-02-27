# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Benefits", type: :request do
  include Devise::Test::IntegrationHelpers
  
  before(:all) do
    Devise.mappings[:user] ||= Devise.add_mapping(:user, {})
  end
  
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET /benefits" do
    context 'when successful' do
      let!(:active_benefit) { create(:user_benefit, user: user, amount: 100) }

      it 'returns a successful response' do
        get benefits_path
        expect(response).to be_successful
      end
    end

    context 'when benefits cannot be loaded' do
      before do
        allow_any_instance_of(User).to receive_message_chain(:user_benefits, :active_benefits)
          .and_raise(ActiveRecord::RecordNotFound)
      end

      it 'redirects to root with error message' do
        get benefits_path
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq('Unable to load benefits information')
      end
    end

    context 'when unexpected error occurs' do
      before do
        allow_any_instance_of(User).to receive_message_chain(:user_benefits, :active_benefits)
          .and_raise(StandardError)
      end

      it 'redirects to root with error message' do
        get benefits_path
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq('An unexpected error occurred while loading your benefits')
      end
    end

    context 'when benefit allocation fails' do
      before do
        allow_any_instance_of(UserBenefitService::Allocator).to receive(:call)
          .and_raise(StandardError)
      end

      it 'redirects to root with error message' do
        get benefits_path
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq('Unable to process benefits allocation')
      end
    end
  end
end 