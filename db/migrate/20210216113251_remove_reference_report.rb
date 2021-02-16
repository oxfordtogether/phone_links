class RemoveReferenceReport < ActiveRecord::Migration[6.0]
  def change
    remove_reference :reports, :matches, null: false, foreign_key: true
  end
end
