# frozen_string_literal: true

# Scoring Helper
module ScoringHelper
  def unscored_scores(matchday)
    Score.where(matchday_id: matchday, points: 0).pluck(:team_id)
  end

  def finished_matches_data(matchday)
    FootballData::Client.finished_matches(matchday)['matches']
  end

  def code_to_team
    path = Rails.public_path.join('teamMap.json')
    JSON.parse(File.read(path))
  end
end
