class Rule < ApplicationRecord
  belongs_to :benefit

  store :conditions, accessors: %i[max_seniority min_seniority location contract_type], coder: JSON

  validates :name, :amount, presence: true

  def matches_user_conditions?(user)
    return false unless conditions.present?

    [
      seniority_condition(user),
      location_condition(user),
      contract_type_condition(user)
    ].all?(true)
  end

  private

  def seniority_condition(user)
    return true unless min_seniority.present? || max_seniority.present?

    check_seniority(user.seniority, min_seniority, max_seniority)
  end

  def location_condition(user)
    return true unless location.present?

    user.location == location
  end

  def contract_type_condition(user)
    return true unless contract_type.present?

    user.contract_type == contract_type
  end

  def check_seniority(user_seniority, min_seniority, max_seniority)
    min_check = min_seniority.nil? || user_seniority >= min_seniority.to_i
    max_check = max_seniority.nil? || user_seniority <= max_seniority.to_i
    min_check && max_check
  end
end
