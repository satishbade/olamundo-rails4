class AddSymbolTypeToSymbol1 < ActiveRecord::Migration
  def change
    add_column :symbol1s, :symbol_type, :string
  end
end
