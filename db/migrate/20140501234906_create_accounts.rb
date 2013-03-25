class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.decimal :balance
      t.date :payment_due_date
      t.integer :state

      t.references :member
      t.timestamps
    end

    add_index :accounts, :member_id
  end
end
