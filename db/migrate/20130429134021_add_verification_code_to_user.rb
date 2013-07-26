class AddVerificationCodeToUser < Mongoid::Migration
  def change
    add_column :users, :verification_code, :string
  end
end
