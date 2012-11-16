class RemoveParentIdAndContainerIdFromDbfiles < ActiveRecord::Migration
  def self.up
    remove_column :dbfiles, :parent_id
    remove_column :dbfiles, :container_id
  end

  def self.down
    add_column :dbfiles, :parent_id, :integer
    add_column :dbfiles, :container_id, :integer
  end
end
