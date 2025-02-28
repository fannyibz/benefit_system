# frozen_string_literal: true

class BenefitsController < ApplicationController
  before_action :authenticate_user!
  before_action :auto_create_user_benefits, only: [:index]
  before_action :set_locale

  def index
    begin
      @active_benefits = current_user.user_benefits.active_benefits
      @total_available = @active_benefits.sum(&:amount)
    rescue ActiveRecord::RecordNotFound => e
      flash[:error] = "Unable to load benefits information"
      redirect_to root_path
    rescue StandardError => e
      flash[:error] = "An unexpected error occurred while loading your benefits"
      redirect_to root_path
    end
  end

  private

  def auto_create_user_benefits
    begin
      UserBenefitService::Allocator.new(current_user).call
    rescue StandardError => e
      flash[:error] = "Unable to process benefits allocation"
      redirect_to root_path
    end
  end

  def set_locale
    I18n.locale = :fr
  end
end 