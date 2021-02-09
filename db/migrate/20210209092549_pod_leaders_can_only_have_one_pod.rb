class PodLeadersCanOnlyHaveOnePod < ActiveRecord::Migration[6.0]
  def change
    remove_index :pods, :pod_leader_id
    add_index :pods, :pod_leader_id, unique: true
  end
end
