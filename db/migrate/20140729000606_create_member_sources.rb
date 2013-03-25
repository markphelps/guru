class CreateMemberSources < ActiveRecord::Migration
  def change
    create_table :member_sources do |t|
      t.string :name

      t.references :studio
      t.timestamps
    end

    add_index :member_sources, :studio_id
  end
end
