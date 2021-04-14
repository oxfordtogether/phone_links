class PodSupporters < ActiveRecord::Migration[6.0]
  def change
    create_table :pod_supporters do |t|
      t.references :pod, foreign_key: true, null: false
      t.references :supporter, foreign_key: { to_table: :pod_leaders }, null: false
    end
  end
end
