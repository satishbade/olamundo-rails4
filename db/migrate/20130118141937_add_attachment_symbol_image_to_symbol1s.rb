class AddAttachmentSymbolImageToSymbol1s < Mongoid::Migration
  def self.up
    change_table :symbol1s do |t|
      t.has_attached_file :symbol_image
    end
  end

  def self.down
    drop_attached_file :symbol1s, :symbol_image
  end
end
