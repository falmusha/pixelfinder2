class AddThumbnailAndImageUrlsToImages < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :thumbnail_url, :string
    add_column :images, :image_url, :string
    rename_column :images, :url, :page_url
  end
end
