class AddMemberIdToUserContact < ActiveRecord::Migration
  def change
    add_column :user_contacts, :member_id, :integer
  end
end
