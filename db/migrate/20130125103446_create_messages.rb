class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :message_from
      t.string :message_to
      t.text :message
      t.integer :message_time
      t.string :read

      t.timestamps
    end
  end
end
