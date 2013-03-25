class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.date :due_date
      t.date :payment_date
      t.decimal :amount_due
      t.decimal :payment_amount
      t.string :payment_method

      t.references :account
      t.timestamps
    end

    add_index :payments, :account_id
  end
end
