class PersonRoleModels < ActiveRecord::Migration[6.0]
  def change
    create_table :people do |t|
      t.timestamps

      t.text :title_ciphertext, null: true
      t.text :first_name_ciphertext, null: false
      t.text :last_name_ciphertext, null: false
      t.text :phone_ciphertext, null: true
      t.text :email_ciphertext, null: true
      t.text :address_line_1_ciphertext, null: true
      t.text :address_line_2_ciphertext, null: true
      t.text :address_town_ciphertext, null: true
      t.text :address_postcode_ciphertext, null: true
      t.string :auth0_id, null: true
    end

    create_table :callers do |t|
      t.timestamps

      t.references :person, null: false, foreign_key: true, index: true

      t.date :start_date, null: false
      t.date :end_date, null: true
    end

    create_table :callees do |t|
      t.timestamps

      t.references :person, null: false, foreign_key: true, index: true

      t.date :start_date, null: false
      t.date :end_date, null: true
    end

    create_table :admins do |t|
      t.timestamps

      t.references :person, null: false, foreign_key: true, index: true

      t.date :start_date, null: false
      t.date :end_date, null: true
    end

    create_table :pod_leaders do |t|
      t.timestamps

      t.references :person, null: false, foreign_key: true, index: true

      t.date :start_date, null: false
      t.date :end_date, null: true
    end
  end
end
