class AddSequenceAndImageUrlToRelatedsymbol < Mongoid::Migration
  def change
    add_column :relatedsymbols, :image_url, :string
    add_column :relatedsymbols, :sequence, :Integer
  end
end
