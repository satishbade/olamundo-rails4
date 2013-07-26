class AddUserContactIdToMessage < Mongoid::Migration
  def change
    add_column :messages, :user_contact_id, :integer
  end
end
