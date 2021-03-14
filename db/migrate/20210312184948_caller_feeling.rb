class CallerFeeling < ActiveRecord::Migration[6.0]
  def change
    rename_column :reports, :caller_confidence, :caller_feeling
    rename_column :reports, :callee_state, :callee_feeling
  end
end
