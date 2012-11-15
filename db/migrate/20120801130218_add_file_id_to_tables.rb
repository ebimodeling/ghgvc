class AddFileIdToTables < ActiveRecord::Migration
  def self.up
    add_column :dbfiles, :file_id, :integer
    add_column :inputs, :file_id, :integer
  end

  def self.down
    remove_column :dbfiles, :file_id, :integer
    remove_column :inputs, :file_id, :integer
  end
end
