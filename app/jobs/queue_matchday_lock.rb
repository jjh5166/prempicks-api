# frozen_string_literal: true

# set current matchday, lock Matchday if lock_time passed
class QueueMatchdayLock < ActiveJob::Base
  include MatchdayHelper
  def perform
    mds = matchdays_to_lock
    return unless mds.any?

    mds.each do |md|
      md.update(lock_queued: true) if LockMatchday.perform_at(md.lock_time, md.id)
    end
  end
end
