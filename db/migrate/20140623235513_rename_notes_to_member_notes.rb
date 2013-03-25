class RenameNotesToMemberNotes < ActiveRecord::Migration
  def change
    rename_table :notes, :member_notes
  end
end
