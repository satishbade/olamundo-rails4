class RemoveUserIdFromUserContact < Mongoid::Migration
  def up
    remove_column :user_contacts, :user_id
  end

  def down
    add_column :user_contacts, :user_id, :integer
  end
end
