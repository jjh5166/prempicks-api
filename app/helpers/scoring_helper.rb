# frozen_string_literal: true

# Scoring Helper
module ScoringHelper
  # returns array of team_ids for Scores with 0 points
  def unscored_scores(matchday)
    Score.where(matchday_id: matchday, points: 0, season: CURRENT_SEASON).pluck(:team_id)
  end

  # returns array of match objects from FootballApi for finished matches
  def finished_matches_data(matchday)
    FootballData::Client.finished_matches(matchday)['matches']
  end

  # returns hash map of team ids from FootballApi to team info
  def code_to_team
    path = Rails.public_path.join('teamMap.json')
    JSON.parse(File.read(path))
  end

  # loop through FootballApi call and update Scores for finished matches
  def score_matchday(matchday)
    matches = finished_matches_data(matchday)
    unscored = unscored_scores(matchday)
    teams = code_to_team

    matches.each do |match|
      home_team = teams[match['homeTeam']['id'].to_s]['abv']
      next unless unscored.include?(home_team)

      away_team = teams[match['awayTeam']['id'].to_s]['abv']
      if match['score']['winner'] == 'DRAW'
        score_draw(matchday, [home_team, away_team])
      else
        score_non_draw(
          matchday,
          home_team, match['score']['fullTime']['homeTeam'],
          away_team, match['score']['fullTime']['awayTeam']
        )
      end
    end
  end

  def score_draw(matchday, teams)
    Score.where(matchday_id: matchday, team_id: teams, season: CURRENT_SEASON).update(points: 1)
  end

  def score_non_draw(matchday, home_team, home_goals, away_team, away_goals)
    diff = home_goals - away_goals
    scores = score_base_and_gd(diff)
    winner = diff.positive? ? home_team : away_team
    loser = diff.positive? ? away_team : home_team

    add_half_point(scores) if diff.negative?
    add_bonus_point(scores) if (home_goals * away_goals).zero?
    add_bonus_point(scores) & deduct_point(scores) if top_six?(loser)
    add_bonus_point(scores) if newly_promoted?(winner)

    Score.where(matchday_id: matchday, team_id: winner, season: CURRENT_SEASON).update(points: scores.max)
    Score.where(matchday_id: matchday, team_id: loser, season: CURRENT_SEASON).update(points: scores.min)
  end

  # returns array of points for W/L/D results and calculates GD factor
  def score_base_and_gd(difference)
    return [3, -4] if difference >= 3

    return [2, -3] if difference.positive?

    return [-4, 3] if difference <= -3

    [-3, 2]
  end

  def top_six?(team)
    TOP_SIX.include?(team)
  end

  def newly_promoted?(team)
    NEWLY_PROMOTED.include?(team)
  end

  def add_bonus_point(scores)
    max = scores.max
    scores[scores.index(max)] += 1
  end

  def add_half_point(scores)
    max = scores.max
    scores[scores.index(max)] += 0.5
  end

  def deduct_point(scores)
    min = scores.min
    scores[scores.index(min)] -= 1
  end
end
