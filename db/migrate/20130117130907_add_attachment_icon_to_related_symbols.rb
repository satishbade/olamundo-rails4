class AddAttachmentIconToRelatedSymbols < Mongoid::Migration
  def self.up
    change_table :related_symbols do |t|
      t.has_attached_file :icon
    end
  end

  def self.down
    drop_attached_file :related_symbols, :icon
  end
end
