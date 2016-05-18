class AddLastMetaDataFetchDateToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :last_metadata_fetch_date, :datetime
  end
end
