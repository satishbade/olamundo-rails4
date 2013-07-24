class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :category_name
      t.integer :member_id
      t.timestamps
    end
  end
end
