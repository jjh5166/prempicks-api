# frozen_string_literal: true

# updates scores for matchday
class ScorerWorker
  include Sidekiq::Worker
  include ScoringHelper
  def perform(matchday)
    score_matchday(matchday)
  end
end
