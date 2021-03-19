class InviteEmails < ActiveRecord::Migration[6.0]
  def change
    add_column :people, :invite_email_sent_at, :datetime
  end
end
