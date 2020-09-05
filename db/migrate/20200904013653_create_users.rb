class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users, id: false do |t|
      t.string :uid, null: false
      t.string :email, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :team_name, null: false
      t.timestamps
    end

    add_index :users, :uid, unique: true
  end
end
