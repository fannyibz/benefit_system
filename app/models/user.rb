# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, :email, :start_date, :location, :contract_type, presence: true
  validates :email, uniqueness: { case_sensitive: false },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i,
                              message: "must be a valid email address" }

  has_many :reimbursements
  has_many :user_benefits
  has_many :benefits, through: :user_benefits
  has_many :rules, through: :user_benefits

  def seniority
    return 0 unless start_date

    ((Time.current - start_date.to_time) / 1.year).floor
  end

  def existing_user_benefits(benefit, time_period)
    user_benefits.active_benefits
                 .where(benefit: benefit)
                 .where('created_at >= ?', time_period)
                 .order(created_at: :desc)
  end

  def eligible_rule_for_benefit(benefit)
    benefit.rules.select { |rule| rule.matches_user_conditions?(self) }.first
  end
end
