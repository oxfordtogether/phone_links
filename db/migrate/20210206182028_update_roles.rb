class UpdateRoles < ActiveRecord::Migration[6.0]
  def change
    remove_column :callers, :start_date
    remove_column :callers, :end_date
    remove_column :callees, :start_date
    remove_column :callees, :end_date
    remove_column :admins, :start_date
    remove_column :admins, :end_date
    remove_column :pod_leaders, :start_date
    remove_column :pod_leaders, :end_date
  end
end
