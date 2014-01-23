class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :initiator_id
      t.integer :invited_id
      t.string :status
      t.integer :wins
      t.integer :loses

      t.timestamps
    end
  end
end
