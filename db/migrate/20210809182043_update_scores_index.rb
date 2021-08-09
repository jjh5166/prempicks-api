class UpdateScoresIndex < ActiveRecord::Migration[6.0]
  def change
    remove_index :scores, name: :score_key
    add_index :scores, %i[matchday_id team_id season], name: 'score_key', unique: true
  end
end
