class AddDefaultSkbToCategory < Mongoid::Migration
  def change
    add_column :categories, :default_skb, :boolean
  end
end
