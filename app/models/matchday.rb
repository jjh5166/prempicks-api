# frozen_string_literal: true

# matchday tracks scoring and locking
class Matchday < ApplicationRecord
  has_many :scores
end
