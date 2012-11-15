class AddRowsToDbFiles < ActiveRecord::Migration
  def self.up
    add_column :dbfiles, :parent, :integer
    remove_column :dbfiles, :file_id
    remove_column :inputs, :file_id
  end

  def self.down
    remove_column :dbfiles, :parent_id
    add_column :dbfiles, :file_id, :integer
    add_column :inputs, :file_id, :integer
  end
end
