# frozen_string_literal: true

require 'sidekiq-scheduler'
# gathers users with missing picks and sends reminder emails# gathers users missing picks and sends reminder emails
class ReminderWorker
  include Sidekiq::Worker
  include PicksHelper
  sidekiq_options queue: 'mailers'
  def perform(matchday)
    users = users_no_pick(matchday)
    return unless users.any?

    users.each do |u|
      UserMailer.reminder_email(u.email).deliver_now
    end
  end
end
