class OpasId < ActiveRecord::Migration[6.0]
  def change
    add_column :people, :opas_id, :string
  end
end
