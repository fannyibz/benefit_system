# frozen_string_literal: true

class BenefitsController < ApplicationController
  before_action :authenticate_user!
  before_action :auto_create_user_benefits, only: [:index]
  before_action :set_locale

  def index
    @active_benefits = current_user.user_benefits.active_benefits
    @total_available = @active_benefits.sum(&:amount)
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Unable to load benefits information"
    redirect_to root_path
  rescue StandardError
    flash[:error] = "An unexpected error occurred while loading your benefits"
    redirect_to root_path
  end

  private

  def auto_create_user_benefits
    UserBenefitService::Allocator.new(current_user).call
  rescue StandardError
    flash[:error] = "Unable to process benefits allocation"
    redirect_to root_path
  end

  def set_locale
    I18n.locale = :fr
  end
end
