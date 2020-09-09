class CreateScores < ActiveRecord::Migration[6.0]
  def change
    create_table :scores do |t|
      t.references :matchday, null: false, type: :integer
      t.string :team_id, null: false
      t.integer :points, null: false, default: 0
      t.timestamps
    end
    add_index :scores, %i[matchday_id team_id], name: 'score_key', unique: true
  end
end
