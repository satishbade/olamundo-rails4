class CreateSymbol1s < Mongoid::Migration
  def change
    create_table :symbol1s do |t|
      t.integer :category_id
      t.integer :sequence
      t.string :word

      t.timestamps
    end
  end
end
