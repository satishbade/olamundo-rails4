class AddHebrewToRelatedsymbol < Mongoid::Migration
  def change
    add_column :relatedsymbols, :hebrew, :string
  end
end
