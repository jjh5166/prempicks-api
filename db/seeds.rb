# frozen_string_literal: true

if Matchday.none?
  (1..38).each do |week|
    Matchday.create(id: week)
  end
  # update locktimes
end

if Score.none?
  teams = %w[
    ARS AVL BHA BUR CHE CRY EVE FUL LEE LEI
    LIV MCI MUN NEW SHU SOU TOT WBA WHU WOL
  ]
  teams.each do |t|
    (1..38).each do |week|
      Score.create(team_id: t, matchday_id: week)
    end
  end
end

CurrentMatchday.first_or_create!(singleton_guard: 0, matchday: 1) if CurrentMatchday.none?
