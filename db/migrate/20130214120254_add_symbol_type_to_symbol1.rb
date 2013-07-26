class AddSymbolTypeToSymbol1 < Mongoid::Migration
  def change
    add_column :symbol1s, :symbol_type, :string
  end
end
