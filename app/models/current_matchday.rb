# frozen_string_literal: true

# singleton reference to current matchday
class CurrentMatchday < ApplicationRecord
  validates_inclusion_of :singleton_guard, in: [0]
end
