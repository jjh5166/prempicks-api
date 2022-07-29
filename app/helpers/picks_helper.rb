# frozen_string_literal: true

# Picks Helper
module PicksHelper
  # users who have no selection on matchday
  def users_no_pick(matchday)
    User.where(live: true).joins(:picks).where('picks.matchday' => matchday, 'picks.team_id' => '', 'picks.season' => CURRENT_SEASON)
  end

  # autopick if there are users without picks on matchday
  def autopick_on_lock(matchday)
    users = users_no_pick(matchday)
    return unless users

    auto_pick(matchday, users)
  end

  def auto_pick(matchday, users)
    half = matchday < 20 ? 1 : 2
    locked_matchdays = Matchday.where(locked: true).pluck(:id)
    users.each do |user|
      picked = user.picks.where(matchday: locked_matchdays, half: half, season: CURRENT_SEASON).pluck(:team_id).reject(&:blank?)
      to_pick = find_pick(picked)
      make_autopick(user, to_pick, matchday)
    end
  end

  # find pick based on prev years standings
  def find_pick(picks)
    lastyr = %w[ MCI MUN LIV CHE LEI WHU TOT ARS LEE EVE 
                 AVL NEW WOL CRY SOU BHA BUR NOR WAT BRE ]
    left = lastyr - picks
    left[0]
  end

  # make autopick and clear future pick if needed
  def make_autopick(user, team, matchday)
    half = matchday < 20 ? 1 : 2
    user&.picks&.find_by(team_id: team, half: half, season: CURRENT_SEASON)&.update(team_id: '')
    pick = user.picks.find_by(matchday: matchday, season: CURRENT_SEASON)
    pick.team_id = team
    pick.save(validate: false)
  end
end
