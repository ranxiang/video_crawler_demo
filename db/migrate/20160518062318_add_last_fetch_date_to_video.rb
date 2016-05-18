class AddLastFetchDateToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :last_fetch_date, :datetime
  end
end
