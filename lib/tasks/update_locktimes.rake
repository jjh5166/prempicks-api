# frozen_string_literal: true

require 'task_helpers/football_api_helper'
namespace :footballApi do
  include FootballApiHelper
  desc 'Update lock_time on Matchdays'
  task update_locktimes: :environment do
    update_locktimes
  end
end
