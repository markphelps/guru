class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.date :visit_date

      t.references :member
      t.references :klass
      t.timestamps
    end

    add_index :visits, :member_id
    add_index :visits, :klass_id
  end
end
