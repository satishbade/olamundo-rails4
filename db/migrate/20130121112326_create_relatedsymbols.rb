class CreateRelatedsymbols < Mongoid::Migration
  def change
    create_table :relatedsymbols do |t|
      t.integer :symbol1_id
      t.string :symbol_text

      t.timestamps
    end
  end
end
