class MatchDeletedAt < ActiveRecord::Migration[6.0]
  def change
    remove_column :matches, :pending

    add_column :matches, :deleted_at, :datetime
  end
end
