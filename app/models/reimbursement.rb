# frozen_string_literal: true

class Reimbursement < ApplicationRecord
  belongs_to :user_benefit
  belongs_to :user
  
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validate :sufficient_balance
  
  private
  
  def sufficient_balance
    if amount && amount > user_benefit.amount
      errors.add(:amount, "ne peut pas dépasser le solde disponible")
    end
  end
end 
