# frozen_string_literal: true

class Benefit < ApplicationRecord
  validates :name, presence: true

  enum :recurrence, { one_time: 0, monthly: 1, yearly: 2 }
end 