class AddCalleesToPod < ActiveRecord::Migration[6.0]
  def change
    add_reference :callees, :pod, null: true, foreign_key: true, index: true
  end
end
