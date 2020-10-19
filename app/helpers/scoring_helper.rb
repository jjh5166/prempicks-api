# frozen_string_literal: true

# Scoring Helper
module ScoringHelper
  def unscored_scores(matchday)
    Score.where(matchday_id: matchday, points: 0)
  end
end
