class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :name
      t.text :desc
      t.string :origin_link
      t.string :creator_name
      t.text :creator_desc
      t.integer :num_of_views
      t.integer :num_of_comments

      t.timestamps null: false
    end
  end
end
