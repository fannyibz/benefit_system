class Rule < ApplicationRecord
  belongs_to :benefit

  store :conditions, accessors: [:seniority, :location, :contract_type], coder: JSON

  validates :name, :amount, presence: true
end