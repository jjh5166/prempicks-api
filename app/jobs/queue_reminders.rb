# frozen_string_literal: true

# queue email reminders job for 24hr before lock time
class QueueReminders < ActiveJob::Base
  include MatchdayHelper
  def perform
    md = matchday_to_remind
    return unless md

    ReminderWorker.perform_at(md.lock_time - 1.day, md.id)
    md.update(reminders_queued: true)
  end
end
