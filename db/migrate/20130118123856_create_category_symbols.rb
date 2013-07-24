class CreateCategorySymbols < ActiveRecord::Migration
  def change
    create_table :category_symbols do |t|
      t.integer :category_id
      t.integer :sequence
      t.string :word
      t.timestamps
    end
  end
end
