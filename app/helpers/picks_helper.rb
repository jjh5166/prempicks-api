# frozen_string_literal: true

# Picks Helper
module PicksHelper
  # users who have no selection on matchday
  def users_no_pick(matchday)
    User.joins(:picks).where('picks.matchday' => matchday, 'picks.team_id' => '')
  end

  # autopick if there are users without picks on matchday
  def autopick_on_lock(matchday)
    users = users_no_pick(matchday)
    return unless users

    auto_pick(matchday, users)
  end

  def auto_pick(matchday, users)
    start = matchday < 20 ? 1 : 20
    users.each do |user|
      picked = user.picks.where(matchday: start..matchday).pluck(:team_id).reject(&:blank?)
      to_pick = find_pick(picked)
      make_autopick(user, to_pick, matchday)
    end
  end

  # find pick based on prev years standings
  def find_pick(picks)
    lastyr = %w[ LIV MCI MUN CHE LEI TOT WOL ARS SHU BUR
                 SOU EVE NEW CRY BHA WHU AVL LEE WBA FUL]
    left = lastyr - picks
    left[0]
  end

  # make autopick and clear future pick if needed
  def make_autopick(user, team, matchday)
    half = matchday < 20 ? 1 : 2
    user&.picks&.find_by(team_id: team, half: half)&.update(team_id: '')
    pick = user.picks.find_by(matchday: matchday)
    pick.team_id = team
    pick.save(validate: false)
  end
end
