# frozen_string_literal: true

# set current matchday, lock Matchday if lock_time passed
class QueueRemindersJob < ActiveJob::Base
  include MatchdayHelper
  def perform
    md = matchday_to_remind
    return unless md

    ReminderWorker.perform_at(md.lock_time - 1.day, md.id)
    md.update(reminders_queued: true)
  end
end
