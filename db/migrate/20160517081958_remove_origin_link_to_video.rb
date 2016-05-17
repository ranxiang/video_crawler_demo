class RemoveOriginLinkToVideo < ActiveRecord::Migration
  def change
    remove_column :videos, :origin_link
  end
end
