class CallerCheckIns < ActiveRecord::Migration[6.0]
  def change
    add_column :callers, :check_in_frequency, :string
  end
end
