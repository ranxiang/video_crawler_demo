class AddActiveToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :active, :boolean
  end
end
