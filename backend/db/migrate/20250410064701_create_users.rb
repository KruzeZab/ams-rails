class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_enum :gender_type, [ "m", "f", "o" ]
    create_enum :role_type, [ "super_admin", "artist_manager", "artist" ]

    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :password_digest
      t.datetime :dob
      t.enum :gender, enum_type: :gender_type, null: false
      t.string :address
      t.enum :role, enum_type: :role_type, null: false

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
