class CreateRelatedSymbols < ActiveRecord::Migration
  def change
    create_table :related_symbols do |t|
      t.string :symbol_text
      t.integer :symbol1_id
      t.timestamps
    end
  end
end
