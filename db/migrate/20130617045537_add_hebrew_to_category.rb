class AddHebrewToCategory < Mongoid::Migration
  def change
    add_column :categories, :hebrew, :string
  end
end
