class AddLevelToSymbol1 < Mongoid::Migration
  def change
    add_column :symbol1s, :level, :integer
  end
end
