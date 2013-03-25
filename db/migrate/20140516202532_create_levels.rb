class CreateLevels < ActiveRecord::Migration
  def change
    create_table :levels do |t|
      t.string :name
      t.string :color

      t.references :studio
      t.timestamps
    end

    add_index :levels, :studio_id
  end
end
