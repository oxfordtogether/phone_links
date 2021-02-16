class AddReferencesToReports < ActiveRecord::Migration[6.0]
  def change
    add_reference :reports, :match, null: false, foreign_key: true
  end
end
