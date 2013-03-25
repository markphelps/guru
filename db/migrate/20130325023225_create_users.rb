class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.boolean :admin
      t.boolean :owner

      t.references :studio
      t.timestamps
    end

    add_index :users, :studio_id
  end
end
