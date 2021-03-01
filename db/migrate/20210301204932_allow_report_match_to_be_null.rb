class AllowReportMatchToBeNull < ActiveRecord::Migration[6.0]
  def change
    change_column_null :reports, :match_id, true
  end
end
