class CreateCameras < ActiveRecord::Migration[5.0]
  def change
    create_table :cameras do |t|
      t.string :model
      t.float :resolution
      t.references :manufacturer, foreign_key: true
      t.references :sensor_type, foreign_key: true
      t.integer :mount_id

      t.timestamps
    end
  end
end
