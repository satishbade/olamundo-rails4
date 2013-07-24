class AddHebrewToSymbol1s < ActiveRecord::Migration
  def change
    add_column :symbol1s, :hebrew, :string
  end
end
