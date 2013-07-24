class RenameRelationShipColumnToRelationship < ActiveRecord::Migration
  def self.up
    rename_column :members, :relation_ship, :relationship
  end

  def self.down
    rename_column :members, :relationship, :relation_ship
  end
end
