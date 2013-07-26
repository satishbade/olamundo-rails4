class AddImageUrlToSymbol1 < Mongoid::Migration
  def change
    add_column :symbol1s, :image_url, :string
  end
end
