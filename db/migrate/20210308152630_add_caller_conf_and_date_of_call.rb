class AddCallerConfAndDateOfCall < ActiveRecord::Migration[6.0]
  def change
    add_column :reports, :caller_confidence, :string
    add_column :reports, :date_of_call, :date
  end
end
