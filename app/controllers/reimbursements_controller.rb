# frozen_string_literal: true

class ReimbursementsController < ApplicationController
  before_action :authenticate_user!

  def new
    @reimbursement = Reimbursement.new(user_benefit_id: params[:user_benefit_id])
    @user_benefits = current_user.user_benefits.active_benefits
  end

  def create
    @reimbursement = current_user.reimbursements.new(reimbursement_params)

    if @reimbursement.save
      user_benefit = @reimbursement.user_benefit
      user_benefit.update(amount: user_benefit.amount - @reimbursement.amount)

      redirect_to benefits_path, notice: 'Demande de paiement soumise avec succès'
    else
      @user_benefits = current_user.user_benefits.active_benefits
      render :new, status: :unprocessable_entity
    end
  end

  private

  def reimbursement_params
    params.require(:reimbursement).permit(:amount, :description, :user_benefit_id)
  end
end
