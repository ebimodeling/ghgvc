class FixParentInDbFiles < ActiveRecord::Migration
  def self.up
    # if parent col exists ... remove it
    remove_column :dbfiles, :parent #unless !DBFile.column_names.include?('parent')
    # if parent_id col exists ... dont add it
    add_column :dbfiles, :parent_id, :integer #unless DBFile.column_names.include?('parent_id')
  end

  def self.down
    # if parent col doesnt exist ... add it
    add_column :dbfiles, :parent, :integer #if !DBFile.column_names.include?('parent')
    # if parent_id col does exist ... remove it
    remove_column :dbfiles, :parent_id #if DBFile.column_names.include?('parent_id')
  end
end
