class AddHebrewToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :hebrew, :string
  end
end
