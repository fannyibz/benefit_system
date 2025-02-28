# frozen_string_literal: true

class UserBenefit < ApplicationRecord
  belongs_to :user
  belongs_to :benefit
  belongs_to :rule
  has_many :reimbursements

  enum :status, { active: 0, inactive: 1 }

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :amount_to_grant, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :granted_at, presence: true
  validates :status, presence: true

  scope :active_benefits, -> { where(status: :active) }
  scope :current_year, -> { where('created_at >= ?', Time.current.beginning_of_year) }

  before_create :set_initial_status

  def available_balance
    amount - reimbursements.sum(:amount)
  end

  private

  def set_initial_status
    self.status ||= :active
  end
end
