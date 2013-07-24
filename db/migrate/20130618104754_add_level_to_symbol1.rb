class AddLevelToSymbol1 < ActiveRecord::Migration
  def change
    add_column :symbol1s, :level, :integer
  end
end
