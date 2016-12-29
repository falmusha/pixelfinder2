class AddIndexingToImages < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :images, :creators
    add_index :images, :creator_id
    add_foreign_key :images, :cameras
    add_index :images, :camera_id
    add_foreign_key :images, :lenses
    add_index :images, :lens_id
  end
end
