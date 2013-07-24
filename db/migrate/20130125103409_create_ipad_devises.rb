class CreateIpadDevises < ActiveRecord::Migration
  def change
    create_table :ipad_devises do |t|
      t.text :devise_token
      t.string :status
      t.integer :member_id

      t.timestamps
    end
  end
end
