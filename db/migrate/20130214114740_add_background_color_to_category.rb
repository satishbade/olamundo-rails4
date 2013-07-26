class AddBackgroundColorToCategory < Mongoid::Migration
  def change
    add_column :categories, :background_color, :string
  end
end
