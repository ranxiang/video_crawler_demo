class AddSourceTypeSourceVideoIdToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :source_type, :string
    add_column :videos, :source_video_id, :string
  end
end
