class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :password_digest
      t.datetime :dob
      t.string :gender
      t.string :address
      t.string :role

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
