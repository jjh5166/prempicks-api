class AddSeason < ActiveRecord::Migration[6.0]
  def change
    add_column :current_matchdays, :season, :string, null: false, default: '0000'
    add_column :picks, :season, :string, null: false, default: '0000'
    add_column :scores, :season, :string, null: false, default: '0000'
  end
end
