class AddRetryCountToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :retry_count, :integer
  end
end
