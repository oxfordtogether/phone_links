class MoveCallerOntoPod < ActiveRecord::Migration[6.0]
  def change
    remove_reference :matches, :pod, index: true, foreign_key: true
    add_reference :callers, :pod, null: true, foreign_key: true, index: true
  end
end
