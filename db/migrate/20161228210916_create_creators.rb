class CreateCreators < ActiveRecord::Migration[5.0]
  def change
    create_table :creators do |t|
      t.string :name
      t.string :email
      t.string :website

      t.timestamps
    end
  end
end
