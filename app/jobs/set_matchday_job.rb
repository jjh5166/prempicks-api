# frozen_string_literal: true

# set current matchday, lock Matchday if lock_time passed
class SetMatchdayJob < ActiveJob::Base
  include FootballApiHelper
  def perform
    md = FootballData::Client.standings['season']['currentMatchday']
    update_matchday_if_later(md)
    lock_these = Matchday.where(locked: false).where('lock_time < ?', DateTime.now.utc)
    lock_these.update(locked: true)
  end
end
