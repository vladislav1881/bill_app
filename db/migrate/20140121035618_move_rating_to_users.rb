class MoveRatingToUsers < ActiveRecord::Migration
  def change
    drop_table :ratings

    add_column :users, :rating, :integer, default: 0
    add_column :users, :robustness, :integer, default: 0
    
    add_index :users, :rating
  end
end
