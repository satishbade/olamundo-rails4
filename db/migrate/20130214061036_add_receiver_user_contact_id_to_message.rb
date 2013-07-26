class AddReceiverUserContactIdToMessage < Mongoid::Migration
  def change
    add_column :messages, :receiver_user_contact_id, :integer
  end
end
