namespace :footballApi do
  desc 'Set Current Matchday'
  task set_matchday: :environment do
    md = FootballData::Client.standings['season']['currentMatchday']
    CurrentMatchday.find(1).update(matchday: md)
  end
end
