# frozen_string_literal: true

require 'sidekiq-scheduler'
# lock matchday and perform autopicks
class LockMatchday
  include Sidekiq::Worker
  include MatchdayHelper
  def perform(matchday)
    lock_matchday(matchday)
  end
end
