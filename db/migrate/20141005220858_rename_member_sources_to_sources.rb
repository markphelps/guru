class RenameMemberSourcesToSources < ActiveRecord::Migration
  def change
    rename_table :member_sources, :sources
  end
end
