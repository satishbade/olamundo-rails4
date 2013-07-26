class AddHebrewToSymbol1s < Mongoid::Migration
  def change
    add_column :symbol1s, :hebrew, :string
  end
end
