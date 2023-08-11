# frozen_string_literal: true

# get today's matches to track what needs to be scored
class SetDailySlate < ActiveJob::Base
  def perform
    matches = FootballDataV4::Client.todays_matches['matches']
    slate = matches.map do |match|
      {
        'id' => match['id'],
        'matchday' => match['matchday'],
        'utcDate' => match['utcDate'],
        'scored' => false
      }
    end
    REDIS.set('daily-slate', slate.to_json)
    current_time = Time.now.utc.to_s
    REDIS.set('score-check-timestamp', current_time)
  end
end
