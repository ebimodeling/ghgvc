class AddDataToRawData < ActiveRecord::Migration
  def self.up
    add_column :raws, :data_file_name,    :string
    add_column :raws, :data_content_type, :string
    add_column :raws, :data_file_size,    :integer
    add_column :raws, :data_updated_at,   :datetime
  end

  def self.down
    remove_column :raws, :data_file_name
    remove_column :raws, :data_content_type
    remove_column :raws, :data_file_size
    remove_column :raws, :data_updated_at
  end
end
