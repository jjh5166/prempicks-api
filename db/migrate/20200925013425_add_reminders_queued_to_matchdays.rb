class AddRemindersQueuedToMatchdays < ActiveRecord::Migration[6.0]
  def change
    add_column :matchdays, :reminders_queued, :boolean, default: false
  end
end
