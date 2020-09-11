# frozen_string_literal: true

# matchday tracks scoring and locking
class Matchday < ApplicationRecord
  has_many :scores
  before_destroy { |_record| raise ReadOnlyRecord }
end
