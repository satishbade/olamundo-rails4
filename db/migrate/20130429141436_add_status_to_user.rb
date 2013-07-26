class AddStatusToUser < Mongoid::Migration
  def change
    add_column :users, :status, :string
  end
end
