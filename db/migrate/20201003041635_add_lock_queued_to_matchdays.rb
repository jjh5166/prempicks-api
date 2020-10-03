class AddLockQueuedToMatchdays < ActiveRecord::Migration[6.0]
  def change
    add_column :matchdays, :lock_queued, :boolean, default: false
  end
end
