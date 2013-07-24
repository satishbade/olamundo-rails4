class AddDefaultSkbToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :default_skb, :boolean
  end
end
