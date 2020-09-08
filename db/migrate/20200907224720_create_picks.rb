class CreatePicks < ActiveRecord::Migration[6.0]
  def change
    create_table :picks do |t|
      t.references :user_uid, references: :users, type: :string, null: false # creates 'user_uid_id'
      t.integer :matchday, null: false
      t.string :team_id, null: false, default: ''
      t.integer :half, null: false

      t.timestamps
    end
    rename_column :picks, :user_uid_id, :user_uid
    add_foreign_key :picks, :users, column: 'user_uid', primary_key: 'uid'
  end
end
