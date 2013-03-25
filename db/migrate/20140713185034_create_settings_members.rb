class CreateSettingsMembers < ActiveRecord::Migration
  def change
    create_table :settings_members do |t|
      t.integer :default_payment_due_day, default: 1
      t.boolean :default_payment_due_day_enabled, default: false

      t.references :studio
      t.timestamps
    end
    add_index :settings_members, :studio_id
  end
end
