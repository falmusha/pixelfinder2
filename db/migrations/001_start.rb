Sequel.migration do
  change do
    create_table(:creators) do
      primary_key :id
      String :name, unique: true
      String :email
      String :website
      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end

    create_table(:manufacturers) do
      primary_key :id
      String :name, unique: true, null: false
      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end

    create_table(:sensor_types) do
      primary_key :id
      String :name, unique: true
      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end

    create_table(:cameras, ignore_index_errors: true) do
      primary_key :id
      String :name
      String :camera_model, unique: true, null: false
      Float :resolution
      foreign_key :manufacturer_id, :manufacturers, key: [:id]
      foreign_key :sensor_type_id, :sensor_types, key: [:id]
      Integer :mount_id
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index [:manufacturer_id], name: :index_cameras_on_manufacturer_id
      index [:sensor_type_id], name: :index_cameras_on_sensor_type_id
    end

    create_table(:lenses, ignore_index_errors: true) do
      primary_key :id
      String :name
      String :lens_model, unique: true, null: false
      Float :min_aperture
      Float :max_aperture
      Integer :min_focal_length
      Integer :max_focal_length
      foreign_key :manufacturer_id, :manufacturers, key: [:id]
      foreign_key :sensor_type_id, :sensor_types, key: [:id]
      Integer :mount_id
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index [:manufacturer_id], name: :index_lenses_on_manufacturer_id
      index [:sensor_type_id], name: :index_lenses_on_sensor_type_id
    end

    create_table(:photos, ignore_index_errors: true) do
      primary_key :id
      String :page_url, unique: true
      Float :aperture
      Float :shutter_speed # in millie seconds
      Integer :iso
      Integer :focal_length
      jsonb :exif
      String :source
      String :thumbnail_url, unique: true
      String :photo_url, unique: true
      foreign_key :creator_id, :creators, key: [:id]
      foreign_key :camera_id, :cameras, key: [:id]
      foreign_key :lens_id, :lenses, key: [:id]
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index [:camera_id], name: :index_photos_on_camera_id
      index [:creator_id], name: :index_photos_on_creator_id
      index [:lens_id], name: :index_photos_on_lens_id
    end
  end
end
