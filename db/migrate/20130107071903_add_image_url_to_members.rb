class AddImageUrlToMembers < ActiveRecord::Migration
  def change
    add_column :members, :image_url, :string
  end
end
