class CreateMatchdays < ActiveRecord::Migration[6.0]
  def change
    create_table :matchdays do |t|
      t.datetime :lock_time
      t.boolean :locked, default: false
      t.boolean :scored, default: false
      t.timestamps
    end
  end
end
