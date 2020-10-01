# frozen_string_literal: true

require "#{Rails.root}/app/helpers/football_api_helper"
namespace :footballApi do
  include FootballApiHelper
  desc 'Set Current Matchday'
  task set_matchday: :environment do
    md = FootballData::Client.standings['season']['currentMatchday']
    update_matchday_if_later(md)
    lock_these = Matchday.where(locked: false).where('lock_time < ?', DateTime.now.utc)
    lock_these.update(locked: true)
  end
end
