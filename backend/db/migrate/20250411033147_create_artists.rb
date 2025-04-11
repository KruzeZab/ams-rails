class CreateArtists < ActiveRecord::Migration[8.0]
  def change
    create_table :artists do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :number_of_albums_released
      t.integer :first_release_year

      t.timestamps
    end
  end
end
