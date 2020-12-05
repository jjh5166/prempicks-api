# frozen_string_literal: true

# helpers for football api related tasks
module FootballApiHelper
  def matchdays_times_for(matchdays)
    all_matches = FootballData::Client.scheduled_matches['matches']

    matchtimes = Hash[matchdays.collect { |md| [md, []] }]
    all_matches.each do |m|
      next unless matchdays.include?(m['matchday'])

      matchtimes[m['matchday']].push(m['utcDate'])
    end
    matchtimes
  end

  # update locktimes for all unlocked Matchdays
  def update_locktimes
    matchdays = Matchday.where(locked: false)
    digits = matchdays.pluck(:id)
    mdtimes = matchdays_times_for(digits)
    matchdays.each do |md|
      md.update(lock_time: mdtimes[md.id].min) if mdtimes[md.id].any?
    end
  end

  # update matchday if api returns a later current matchday than saved in db
  def update_matchday_if_later(md_from_api)
    current_matchday = CurrentMatchday.find(1)
    current_matchday.update(matchday: md_from_api) if md_from_api > current_matchday.matchday
  end
end
