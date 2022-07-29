# frozen_string_literal: true

# initial table values used for every season
CurrentMatchday.first_or_create!(singleton_guard: 0, matchday: 1) if CurrentMatchday.none?

if Matchday.none?
  (1..38).each do |week|
    Matchday.create(id: week)
  end
  # update locktimes
end

# pre season updates
if Score.where(season: CURRENT_SEASON).none?
  teams = %w[ ARS AVL BRE BHA BUR CHE CRY EVE LEE LEI
              LIV MCI MUN NEW NOR SOU TOT WAT WHU WOL ]
  teams.each do |t|
    (1..38).each do |week|
      Score.create(team_id: t, matchday_id: week, season: CURRENT_SEASON)
    end
  end
end