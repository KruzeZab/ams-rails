class CreateMusics < ActiveRecord::Migration[8.0]
  def change
    create_table :musics do |t|
      t.string :title
      t.string :genre
      t.string :album_name
      t.references :artist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
