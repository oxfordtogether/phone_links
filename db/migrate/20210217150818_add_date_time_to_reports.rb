class AddDateTimeToReports < ActiveRecord::Migration[6.0]
  def change
    add_column :reports, :datetime, :datetime
  end
end
