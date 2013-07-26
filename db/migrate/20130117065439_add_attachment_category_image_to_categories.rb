class AddAttachmentCategoryImageToCategories < Mongoid::Migration
  def self.up
    change_table :categories do |t|
      t.has_attached_file :category_image
    end
  end

  def self.down
    drop_attached_file :categories, :category_image
  end
end
