class RemoveCurrentFileIdFromInputs < ActiveRecord::Migration
  def self.up
    remove_column :inputs, :current_file_id
  end

  def self.down
    add_column :inputs, :current_file_id, :integer
  end
end
