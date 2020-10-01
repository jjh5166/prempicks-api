# frozen_string_literal: true

# update locktimes column in Matchdays table
class UpdateLocktimesJob < ActiveJob::Base
  include FootballApiHelper
  def perform
    update_locktimes
  end
end
