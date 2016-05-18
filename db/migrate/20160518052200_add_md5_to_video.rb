class AddMd5ToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :md5, :string
  end
end
