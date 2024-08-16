class ChangePointsToDecimalInScores < ActiveRecord::Migration[6.0]
  def change
    change_column :scores, :points, :decimal, precision: 4, scale: 1, default: 0.0, null: false
  end
end
