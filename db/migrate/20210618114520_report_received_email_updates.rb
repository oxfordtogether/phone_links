class ReportReceivedEmailUpdates < ActiveRecord::Migration[6.0]
  def change
    add_column :pod_leaders, :report_received_email_updates, :boolean
  end
end
