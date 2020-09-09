# frozen_string_literal: true

# scores table updated by script
class Score < ApplicationRecord
  belongs_to :matchday
end
