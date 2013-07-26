class AddSequenceToCategory < Mongoid::Migration
  def change
    add_column :categories, :sequence, :integer
  end
end
