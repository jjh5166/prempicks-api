# frozen_string_literal: true

# Matchday Helper
module MatchdayHelper
  def matchdays_to_lock
    Matchday.where(lock_time: Time.current..24.hours.from_now)
  end

  def matchday_to_remind
    Matchday.find_by(lock_time: 24.hours.from_now..48.hours.from_now, reminders_queued: false)
  end

  def lock_matchday(matchday)
    md = Matchday.find(matchday)
    md.update(locked: true)
    # autopick_on_lock(matchday)
  end
end
