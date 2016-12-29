class CreateLenses < ActiveRecord::Migration[5.0]
  def change
    create_table :lenses do |t|
      t.string :model
      t.float :min_aperture
      t.float :max_aperture
      t.integer :min_focal_length
      t.integer :max_focal_length
      t.references :manufacturer, foreign_key: true
      t.references :sensor_type, foreign_key: true
      t.integer :mount_id

      t.timestamps
    end
  end
end
