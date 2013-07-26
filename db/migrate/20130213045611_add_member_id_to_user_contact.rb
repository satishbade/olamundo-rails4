class AddMemberIdToUserContact < Mongoid::Migration
  def change
    add_column :user_contacts, :member_id, :integer
  end
end
