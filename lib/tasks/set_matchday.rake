# frozen_string_literal: true

require 'task_helpers/football_api_helper'
namespace :footballApi do
  include FootballApiHelper
  desc 'Set Current Matchday'
  task set_matchday: :environment do
    md = FootballData::Client.standings['season']['currentMatchday']
    update_matchday_if_later(md)
  end
end
