class AddLevelToMembers < ActiveRecord::Migration
  def change
    add_column :members, :level_id, :integer
    add_index :members, :level_id
  end
end
