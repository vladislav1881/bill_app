class SetDefaultValuesForGames < ActiveRecord::Migration
  def change
    change_column_default :matches, :wins, 0
    change_column_default :matches, :loses, 0
  end
end
