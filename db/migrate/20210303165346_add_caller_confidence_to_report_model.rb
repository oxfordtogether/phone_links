class AddCallerConfidenceToReportModel < ActiveRecord::Migration[6.0]
  def change
    add_column :reports, :caller_confidence, :string
  end
end
