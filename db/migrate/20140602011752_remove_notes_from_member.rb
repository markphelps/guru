class RemoveNotesFromMember < ActiveRecord::Migration
  def change
    change_table :members do |t|
      t.remove :notes
    end
  end
end
