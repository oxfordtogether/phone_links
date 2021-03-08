class AddDateRemoveDatetimeCallerConfInReports < ActiveRecord::Migration[6.0]
  class ChangeDateTimeInReports < ActiveRecord::Migration[6.0]
    def change
      remove_column :reports, :datetime
      add_column :reports, :date_of_call, :date
      add_column :reports, :caller_confidence, :string

    end
  end
end
