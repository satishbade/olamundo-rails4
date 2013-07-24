class AddHebrewToRelatedsymbol < ActiveRecord::Migration
  def change
    add_column :relatedsymbols, :hebrew, :string
  end
end
