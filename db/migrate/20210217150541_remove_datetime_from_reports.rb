class RemoveDatetimeFromReports < ActiveRecord::Migration[6.0]
  def change
    remove_column :reports, :datetime
  end
end
