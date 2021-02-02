class CreatePodsAndMatches < ActiveRecord::Migration[6.0]
  def change
    create_table :pods do |t|
      t.string :name

      t.references :pod_leader, null: true, foreign_key: true

      t.timestamps
    end

    create_table :matches do |t|
      t.date :start_date, null: false
      t.date :end_date, null: true
      t.boolean :pending

      t.references :caller, null: false, foreign_key: true
      t.references :callee, null: false, foreign_key: true
      t.references :pod, null: false, foreign_key: true

      t.timestamps
    end
  end
end
