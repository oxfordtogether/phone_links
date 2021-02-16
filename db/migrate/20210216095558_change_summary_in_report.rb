class ChangeSummaryInReport < ActiveRecord::Migration[6.0]
  def change
    remove_column :reports, :summary
    add_column :reports, :summary_ciphertext, :text

  end
end
