class AddAttachmentSymbolImageToRelatedsymbols < Mongoid::Migration
  def self.up
    change_table :relatedsymbols do |t|
      t.has_attached_file :symbol_image
    end
  end

  def self.down
    drop_attached_file :relatedsymbols, :symbol_image
  end
end
