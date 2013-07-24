class AddBackgroundColorToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :background_color, :string
  end
end
