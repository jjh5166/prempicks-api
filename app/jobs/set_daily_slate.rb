# frozen_string_literal: true

# get today's matches to track what needs to be scored
class SetDailySlate < ActiveJob::Base
  def perform
    matches = FootballDataV4::Client.todays_matches['matches']
    slate = matches.map do |match|
      {
        'id' => match['id'],
        'scored' => false,
        'utcDate' => match['utcDate']
      }
    end

    REDIS.set('daily-slate', slate.to_json)
  end
end
