class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.string :duration
      t.text :summary
      t.date :datetime
      t.string :callee_state

      t.timestamps

      t.references :matches, null: false, foreign_key: true
    end
  end
end
