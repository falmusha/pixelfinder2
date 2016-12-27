class CreateImages < ActiveRecord::Migration[5.0]
  def change
    create_table :images do |t|
      t.string :url
      t.integer :creator_id
      t.integer :camera_id
      t.integer :lens_id
      t.string :aperture
      t.string :shutter_speed
      t.integer :iso
      t.integer :focal_length
      t.jsonb :exif

      t.timestamps
    end
  end
end
