# frozen_string_literal: true

# set current matchday, lock Matchday if lock_time passed
class SetMatchday < ActiveJob::Base
  include FootballApiHelper
  def perform
    md = FootballData::Client.standings['season']['currentMatchday']
    update_matchday_if_later(md)
  end
end
