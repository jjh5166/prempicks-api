# frozen_string_literal: true

# scores table updated by script
class Score < ApplicationRecord
  belongs_to :matchday
  attr_readonly :matchday_id, :team_id
  before_destroy { |_record| raise ReadOnlyRecord }
end
