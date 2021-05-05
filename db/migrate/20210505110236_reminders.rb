class Reminders < ActiveRecord::Migration[6.0]
  def change
    add_column :matches, :report_frequency, :string
    add_column :matches, :alerts_paused_until, :date
  end
end
