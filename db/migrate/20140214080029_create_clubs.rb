class CreateClubs < ActiveRecord::Migration
  def change
    drop_table :clubs if table_exists?(:clubs)
    create_table :clubs do |t|
      t.string :name
      t.string :address
      t.string :description

      t.timestamps
    end
  end
end
