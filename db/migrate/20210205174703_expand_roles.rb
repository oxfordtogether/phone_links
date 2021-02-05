class ExpandRoles < ActiveRecord::Migration[6.0]
  def change
    add_column :callees, :active, :boolean
    add_column :admins, :active, :boolean
    add_column :callers, :active, :boolean
    add_column :pod_leaders, :active, :boolean

    add_column :callers, :experience_ciphertext, :text
    add_column :pods, :theme, :string
    add_column :callees, :reason_for_referral_ciphertext, :text
    add_column :callees, :living_arrangements_ciphertext, :text
    add_column :callees, :other_information_ciphertext, :text
    add_column :callees, :additional_needs_ciphertext, :text
  end
end
