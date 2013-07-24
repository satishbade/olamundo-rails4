class AddImageUrlToSymbol1 < ActiveRecord::Migration
  def change
    add_column :symbol1s, :image_url, :string
  end
end
