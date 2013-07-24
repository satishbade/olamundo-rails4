class CreateSymbolBanks < ActiveRecord::Migration
  def change
    create_table :symbol_banks do |t|

      t.string :symbol_name
      t.string :image_name
      t.string :image_url
      t.has_attached_file :symbol_image

      t.timestamps
    end
  end
end
