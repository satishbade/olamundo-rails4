class CreateMembers < Mongoid::Migration
  def change
    create_table :members do |t|
      t.string :name
      t.string :relation_ship
      t.integer :user_id
      t.timestamps
    end
  end
end
