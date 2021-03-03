class MatchStatus < ActiveRecord::Migration[6.0]
  def change
    add_column :matches, :status, :string

    create_table :match_status_changes do |t|
      t.timestamps

      t.references :match, foreign_key: true

      t.string :status
      t.references :created_by, foreign_key: { to_table: :people }
    end

    add_index :matches, [:callee_id, :caller_id], unique: true
  end
end
