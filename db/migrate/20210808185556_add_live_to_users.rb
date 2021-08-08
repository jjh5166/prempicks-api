class AddLiveToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :live, :boolean, default: false
  end
end
